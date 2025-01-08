/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0022 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0022
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

{esp/esb/out/msg0022.i}

DEFINE TEMP-TABLE tt-transporte LIKE transporte.

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-transporte.
RAW-TRANSFER raw-param TO tt-transporte.

FIND FIRST transporte
    WHERE transporte.cod-transp = tt-transporte.cod-transp NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0022
   DATA-RELATION FOR conteudo, msg0022 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0022r, resultado
   DATA-RELATION FOR conteudor, msg0022r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0022r, resultado RELATION-FIELDS (idm, idm) NESTED.     

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0022'.
       /*cabecalho.LoginUsuario      = c-seg-usuario*/
     
CREATE conteudo.
CREATE msg0022.

FOR FIRST tt-transporte NO-LOCK:

   ASSIGN msg0022.CodigoTransportadora = tt-transporte.cod-transp
          msg0022.Nome                 = tt-transporte.nome
          msg0022.NomeAbreviado        = tt-transporte.nome-abrev
          msg0022.Situacao             = IF AVAIL transporte THEN 0 ELSE 1
          cabecalho.NumeroOperacao     = string(tt-transporte.nome,"x(40)")
          msg0022.CodigoViaTransporte  = tt-transporte.via-transp.
          
END.

IF  NOT AVAIL msg0022 THEN
    cabecalho.NumeroOperacao     = "xxx".



/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */

{esp/esb/esesb003a.i}


RETURN.



