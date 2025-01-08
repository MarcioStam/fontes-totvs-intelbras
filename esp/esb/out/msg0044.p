/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0044 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0044
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-tab-finan like tab-finan.

{esp/esb/out/msg0044.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-tab-finan.
raw-transfer raw-param to tt-tab-finan.

FIND FIRST tab-finan OF tt-tab-finan NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0044
   data-relation for conteudo, msg0044 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0044r, resultado
   data-relation for conteudor, msg0044r relation-fields (idm, idm) nested
   data-relation for msg0044r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0044'.
     
create conteudo.
create msg0044.
      
for each tt-tab-finan no-lock:
    assign msg0044.NumeroTabelaFinanciamento = string(tt-tab-finan.nr-tab-finan)
           msg0044.DataInicioValidade        = tt-tab-finan.dt-ini-val
           msg0044.DataFinalValidade         = tt-tab-finan.dt-fim-val
           msg0044.Situacao                  = IF AVAIL tab-finan THEN 0 ELSE 1
           cabecalho.NumeroOperacao          = string(tt-tab-finan.nr-tab-finan).
end.

       
/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
