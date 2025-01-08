/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0084 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0084
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-tab-unidade like tab-unidade.

{esp/esb/out/msg0084.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-tab-unidade.
raw-transfer raw-param to tt-tab-unidade.

/*Definiá∆o da mensagem de envio de atualizaá∆o*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0084
   data-relation for conteudo, msg0084 relation-fields (idm, idm) nested.

/*Definiá∆o e leitura da mensagem de resposta da atualizaá∆o.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0084r, resultado
   data-relation for conteudor, msg0084r relation-fields (idm, idm) nested
   data-relation for msg0084r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0084'.
     
create conteudo.
create msg0084.

for each tt-tab-unidade no-lock:
   assign msg0084.SiglaUnidadeMedida 	 = tt-tab-unidade.un
          msg0084.DescricaoUnidadeMedida = tt-tab-unidade.un
          msg0084.UnidadeBase        	 = tt-tab-unidade.descricao
          msg0084.Quantidade         	 = 0
          msg0084.GrupoUnidadeMedida 	 = "Unidade Padr∆o"
          cabecalho.NumeroOperacao   	 = tt-tab-unidade.un.
end.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

RETURN.
