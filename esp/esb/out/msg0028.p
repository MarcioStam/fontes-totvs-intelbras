/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0028 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: msg0028
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-fam-com-item like fam-com-item.

{esp/esb/out/msg0028.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-fam-com-item.
raw-transfer raw-param to tt-fam-com-item.

FIND FIRST fam-com-item OF tt-fam-com-item NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0028
   data-relation for conteudo, msg0028 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0028r, resultado
   data-relation for conteudor, msg0028r relation-fields (idm, idm) nested
   data-relation for msg0028r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0028'.
     
create conteudo.
create msg0028.


for each tt-fam-com-item no-lock:

/*     IF tt-fam-com-item.unidade = "99" THEN */ /* Conforme chamado 58053 */
/*         RETURN. */

     assign msg0028.CodigoFamilia          = tt-fam-com-item.unidade + tt-fam-com-item.segmento + tt-fam-com-item.familia1
            msg0028.Nome                   = tt-fam-com-item.descricao
            msg0028.Segmento               = tt-fam-com-item.unidade + tt-fam-com-item.segmento
            msg0028.Situacao               = IF AVAIL fam-com-item THEN 0 ELSE 1
            cabecalho.NumeroOperacao       = string(tt-fam-com-item.descricao,"X(40)"). 
end.
      
  
/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
