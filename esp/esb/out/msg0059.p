/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0059 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0059
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-repres LIKE repres.

{esp/esb/out/msg0059.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-repres.
RAW-TRANSFER raw-param TO tt-repres.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0059
   DATA-RELATION FOR conteudo, msg0059 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0059r, resultado
   DATA-RELATION FOR conteudor, msg0059r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0059r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0059'.
     
CREATE conteudo.
CREATE msg0059.
      
FOR FIRST tt-repres NO-LOCK:
   ASSIGN msg0059.CodigoRepresentante = tt-repres.cod-rep
          cabecalho.NumeroOperacao    = STRING(tt-repres.cod-rep).
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
