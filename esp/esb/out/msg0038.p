/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0038 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0038
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-grup-estoque like grup-estoque.

{esp/esb/out/msg0038.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-grup-estoque.
raw-transfer raw-param to tt-grup-estoque.

FIND FIRST grup-estoque OF tt-grup-estoque NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0038
   data-relation for conteudo, msg0038 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0038r, resultado
   data-relation for conteudor, msg0038r relation-fields (idm, idm) nested
   data-relation for msg0038r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0038'.
     
create conteudo.
create msg0038.

for each tt-grup-estoque no-lock:
    assign msg0038.CodigoGrupoEstoque = tt-grup-estoque.ge-codigo
           msg0038.Nome               = tt-grup-estoque.descricao
           msg0038.Situacao           = IF AVAIL grup-estoque THEN 0 ELSE 1
           cabecalho.NumeroOperacao   = string(tt-grup-estoque.descricao,"x(40)").
end.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
