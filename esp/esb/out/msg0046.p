/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0046 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0046
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-tab-finan-indice like tab-finan-indice.

{esp/esb/out/msg0046.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-tab-finan-indice.
raw-transfer raw-param to tt-tab-finan-indice.

FIND FIRST tab-finan-indice OF tt-tab-finan-indice NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0046
   data-relation for conteudo, msg0046 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0046r, resultado
   data-relation for conteudor, msg0046r relation-fields (idm, idm) nested
   data-relation for msg0046r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0046'.
     
create conteudo.
create msg0046.

for each tt-tab-finan-indice no-lock:
    assign msg0046.ChaveIntegracao     = string(tt-tab-finan-indice.nr-tab-finan) + ";" + string(tt-tab-finan-indice.num-seq)
           msg0046.Indice              = tt-tab-finan-indice.tab-ind-fin
           msg0046.Nome                = string(tt-tab-finan-indice.tab-ind-fin)
           msg0046.NumeroDias          = tt-tab-finan-indice.tab-dia-fin
           msg0046.TabelaFinanciamento = tt-tab-finan-indice.nr-tab-finan
           msg0046.Situacao            = IF AVAIL tab-finan-indice THEN 0 ELSE 1
           cabecalho.NumeroOperacao    = string(tt-tab-finan-indice.tab-ind-fin).
end.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
