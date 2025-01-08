/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0012 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0012
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

DEFINE TEMP-TABLE tt-cidade LIKE mgcad.cidade.

{esp/esb/out/msg0012.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-cidade.
raw-transfer raw-param to tt-cidade.

FIND FIRST mgcad.cidade OF tt-cidade NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0012
   data-relation for conteudo, msg0012 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0012r, resultado
   data-relation for conteudor, msg0012r relation-fields (idm, idm) nested
   data-relation for msg0012r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0012'.
     
create conteudo.
create msg0012.

   for each tt-cidade no-lock:
       assign msg0012.ChaveIntegracao  = tt-cidade.cidade + "," + tt-cidade.estado + "," + tt-cidade.pais
              msg0012.Nome             = tt-cidade.cidade
              msg0012.Estado           = tt-cidade.pais + "," + tt-cidade.estado
              msg0012.CodigoIBGE       = IF tt-cidade.cdn-munpio-ibge = 0 THEN ? ELSE tt-cidade.cdn-munpio-ibge
              msg0012.Situacao         = IF AVAIL cidade THEN 0 ELSE 1 
              cabecalho.NumeroOperacao = tt-cidade.cidade.   
   end.
   
dataset mensagem:write-xml('longchar', oXML, no).

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
