/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0036 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: msg0036
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-fam-comerc LIKE fam-comerc.

{esp/esb/out/msg0036.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-fam-comerc.
RAW-TRANSFER raw-param TO tt-fam-comerc.

FIND FIRST fam-comerc OF tt-fam-comerc NO-LOCK NO-ERROR.
        
/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0036
   DATA-RELATION FOR conteudo, msg0036 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0036r, resultado
   DATA-RELATION FOR conteudor, msg0036r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0036r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0036'.
     
CREATE conteudo.
CREATE msg0036.

FOR EACH tt-fam-comerc NO-LOCK:
/*   IF SUBSTRING(tt-fam-comerc.fm-cod-com,1,2) = "99" THEN */
/*      RETURN.                                             */

  ASSIGN msg0036.CodigoFamilia    = tt-fam-comerc.fm-cod-com
         msg0036.Nome             = tt-fam-comerc.descricao
         msg0036.Segmento         = SUBSTRING(tt-fam-comerc.fm-cod-com,1,4)
         msg0036.Familia          = SUBSTRING(tt-fam-comerc.fm-cod-com,1,5)
         msg0036.SubFamilia       = SUBSTRING(tt-fam-comerc.fm-cod-com,1,7)
         msg0036.Origem           = SUBSTRING(tt-fam-comerc.fm-cod-com,1,8)
         msg0036.Situacao         = IF AVAIL fam-comerc THEN 0 ELSE 1
         cabecalho.NumeroOperacao = string(tt-fam-comerc.descricao,"x(40)").
END.
   
/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN
