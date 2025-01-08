/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0053 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0053
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-tipo-rec-desp like tipo-rec-desp.

{esp/esb/out/msg0053.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-tipo-rec-desp.
raw-transfer raw-param to tt-tipo-rec-desp.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0053
   data-relation for conteudo, msg0053 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0053r, resultado
   data-relation for conteudor, msg0053r relation-fields (idm, idm) nested
   data-relation for msg0053r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0053'.
     
create conteudo.
create msg0053.
      
for each tt-tipo-rec-desp no-lock:
   assign msg0053.CodigoReceitaPadrao = tt-tipo-rec-desp.tp-codigo
          cabecalho.NumeroOperacao    = string(tt-tipo-rec-desp.tp-codigo).
end.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
