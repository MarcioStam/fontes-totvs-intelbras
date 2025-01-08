/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0006 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0006
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

{esp/esb/out/msg0006.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEFINE TEMP-TABLE tt-pais LIKE mgcad.pais.

create tt-pais.
raw-transfer raw-param to tt-pais.

FIND FIRST mgcad.pais OF tt-pais NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name "MENSAGEM" for cabecalho, conteudo, msg0006
   data-relation for conteudo, msg0006 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name "MENSAGEM" for cabecalhor, conteudor, msg0006r, resultado
   data-relation for conteudor, msg0006r relation-fields (idm, idm) nested
   data-relation for msg0006r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0006'.
     
create conteudo.
create msg0006.

for each tt-pais no-lock:
   assign msg0006.ChaveIntegracao  = tt-pais.nome-pais
          msg0006.Nome             = tt-pais.nome-pais
          msg0006.Situacao         = IF AVAIL pais THEN 0 ELSE 1
          cabecalho.NumeroOperacao = tt-pais.nome-pais.
end.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

RETURN.
