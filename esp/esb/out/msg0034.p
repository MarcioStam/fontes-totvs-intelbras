/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0034 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0034
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-familia like familia.

{esp/esb/out/msg0034.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-familia.
raw-transfer raw-param to tt-familia.

FIND FIRST familia OF tt-familia NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0034
   data-relation for conteudo, msg0034 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0034r, resultado
   data-relation for conteudor, msg0034r relation-fields (idm, idm) nested
   data-relation for msg0034r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0034'.
     
create conteudo.
create msg0034.
      
for each tt-familia no-lock:

    IF tt-familia.fm-codigo > "A" THEN
        RETURN.

    assign msg0034.CodigoFamiliaMaterial = IF tt-familia.fm-codigo = "" THEN "0" ELSE tt-familia.fm-codigo
           msg0034.Nome                  = IF tt-familia.descricao = "" THEN "." ELSE trim(string(tt-familia.descricao,"x(150)"))
           msg0034.Situacao              = 0 
           cabecalho.NumeroOperacao      = IF tt-familia.descricao = "" THEN "." ELSE trim(string(tt-familia.descricao,"x(40)")).
end.
   
/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
