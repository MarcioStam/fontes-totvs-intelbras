/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0024 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0024
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-portador like mgcad.portador.

{esp/esb/out/msg0024.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-portador.
raw-transfer raw-param to tt-portador.

FIND FIRST mgcad.portador OF tt-portador NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0024
   data-relation for conteudo, msg0024 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0024r, resultado
   data-relation for conteudor, msg0024r relation-fields (idm, idm) nested
   data-relation for msg0024r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0024'.
     
create conteudo.
create msg0024.

for each tt-portador no-lock:
   assign msg0024.CodigoPortador   = tt-portador.cod-portador
          msg0024.Nome             = tt-portador.nome
          msg0024.Situacao         = IF AVAIL portador THEN 0 ELSE 1
          cabecalho.NumeroOperacao = string(tt-portador.nome,"x(40)").
end.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
