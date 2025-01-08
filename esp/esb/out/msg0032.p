/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0032 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0032
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.
{esp/esb/out/msg0032.i}

define temp-table tt-fam-com-item like fam-com-item.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

define input parameter raw-param as raw no-undo.
DEFINE OUTPUT PARAM TABLE FOR resultado.

create tt-fam-com-item.
raw-transfer raw-param to tt-fam-com-item.

FIND FIRST fam-com-item OF tt-fam-com-item NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0032
   data-relation for conteudo, msg0032 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0032r, resultado
   data-relation for conteudor, msg0032r relation-fields (idm, idm) nested
   data-relation for msg0032r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0032'.
     
create conteudo.
create msg0032.
    
for each tt-fam-com-item no-lock:

/*     IF tt-fam-com-item.unidade = "99" THEN */ /* Conforme chamado 58053 */
/*         RETURN. */

    assign  msg0032.CodigoOrigem     = tt-fam-com-item.unidade + tt-fam-com-item.segmento + tt-fam-com-item.familia1 + tt-fam-com-item.familia2 + tt-fam-com-item.origem
            msg0032.Nome             = tt-fam-com-item.descricao
            msg0032.SubFamilia       = tt-fam-com-item.unidade + tt-fam-com-item.segmento + tt-fam-com-item.familia1 + tt-fam-com-item.familia2
            msg0032.Situacao         = IF AVAIL fam-com-item THEN 0 ELSE 1
            cabecalho.NumeroOperacao = string(tt-fam-com-item.descricao,"x(40)").
end.  

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.

