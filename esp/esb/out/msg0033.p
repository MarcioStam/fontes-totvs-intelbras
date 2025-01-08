/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0033 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0033
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

{esp/esb/out/msg0033.i}

define input parameter raw-param as raw no-undo.
DEFINE OUTPUT PARAM TABLE FOR resultado.
define temp-table tt-fam-com-item like fam-com-item.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-fam-com-item.
raw-transfer raw-param to tt-fam-com-item.


/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0033
   data-relation for conteudo, msg0033 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0033r, resultado
   data-relation for conteudor, msg0033r relation-fields (idm, idm) nested
   data-relation for msg0033r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0033'.
     
create conteudo.
create msg0033.

for each tt-fam-com-item no-lock:
    IF tt-fam-com-item.unidade = "99" THEN
        RETURN.
    assign msg0033.CodigoOrigem     = tt-fam-com-item.origem
           cabecalho.NumeroOperacao = tt-fam-com-item.origem.
end.  

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.

