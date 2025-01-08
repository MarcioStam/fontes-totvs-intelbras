/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0040 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0040
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-canal-venda like canal-venda.

{esp/esb/out/msg0040.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-canal-venda.
raw-transfer raw-param to tt-canal-venda.

FIND FIRST canal-venda OF tt-canal-venda NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0040
   data-relation for conteudo, msg0040 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0040r, resultado
   data-relation for conteudor, msg0040r relation-fields (idm, idm) nested
   data-relation for msg0040r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0040'.
     
create conteudo.
create msg0040.

/*Campo Nome ‚ Obrigatorio na mensagem, tinha um em branco no EMS entao foi desconsiderado*/
IF tt-canal-venda.descricao = "" THEN
    RETURN "NOK":U.

for each tt-canal-venda no-lock:
   assign msg0040.CodigoCanalVenda = tt-canal-venda.cod-canal-venda
          msg0040.Nome             = tt-canal-venda.descricao
          msg0040.Situacao         = IF AVAIL canal-venda THEN 0 ELSE 1
          cabecalho.NumeroOperacao = IF tt-canal-venda.descricao = "" THEN "1" ELSE string(tt-canal-venda.descricao,"x(40)") .
end.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
