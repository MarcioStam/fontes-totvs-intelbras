/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0054 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0054
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-rota like rota.

{esp/esb/out/msg0054.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-rota.
raw-transfer raw-param to tt-rota.

FIND FIRST rota OF tt-rota NO-LOCK NO-ERROR.
    
/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0054
   data-relation for conteudo, msg0054 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0054r, resultado
   data-relation for conteudor, msg0054r relation-fields (idm, idm) nested
   data-relation for msg0054r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0054'.
     
create conteudo.
create msg0054.
      
for each tt-rota no-lock:
    assign msg0054.CodigoRota       = tt-rota.cod-rota
           msg0054.Nome             = tt-rota.descricao
           msg0054.Roteiro          = tt-rota.roteiro
           msg0054.Situacao         = IF AVAIL rota THEN 0 ELSE 1
           cabecalho.NumeroOperacao = string(tt-rota.descricao,"x(40)").
end.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
