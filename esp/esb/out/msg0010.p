/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0010 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0010
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

DEFINE TEMP-TABLE tt-unid-feder LIKE unid-feder.

{esp/esb/out/msg0010.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-unid-feder.
raw-transfer raw-param to tt-unid-feder.

FIND FIRST unid-feder OF tt-unid-feder NO-LOCK NO-ERROR.


/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0010
   data-relation for conteudo, msg0010 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0010r, resultado
   data-relation for conteudor, msg0010r relation-fields (idm, idm) nested
   data-relation for msg0010r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0010'.
     
create conteudo.
create msg0010.

for each tt-unid-feder no-lock:
   assign msg0010.ChaveIntegracao  = tt-unid-feder.pais + "," + tt-unid-feder.estado
          msg0010.Sigla            = tt-unid-feder.estado
          msg0010.Nome             = tt-unid-feder.no-estado
          msg0010.Pais             = tt-unid-feder.pais
          /*msg0010.RegiaoGeografica = ""*/
          msg0010.Situacao         = IF AVAIL unid-feder THEN 0 ELSE 1
          cabecalho.NumeroOperacao = tt-unid-feder.estado.
END.
      
/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.

