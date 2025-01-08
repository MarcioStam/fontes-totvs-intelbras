/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0042 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0042
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-estabelec like estabelec.

{esp/esb/out/msg0042.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-estabelec.
raw-transfer raw-param to tt-estabelec.

FIND FIRST estabelec OF tt-estabelec NO-LOCK NO-ERROR.
    
/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0042
   data-relation for conteudo, msg0042 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0042r, resultado
   data-relation for conteudor, msg0042r relation-fields (idm, idm) nested
   data-relation for msg0042r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0042'.
     
create conteudo.
create msg0042.

for each tt-estabelec no-lock:
   assign msg0042.CodigoEstabelecimento = integer(tt-estabelec.cod-estabel)
          msg0042.Nome                  = tt-estabelec.nome
          msg0042.RazaoSocial           = tt-estabelec.nome
          msg0042.CNPJ                  = tt-estabelec.cgc
          msg0042.InscricaoEstadual     = tt-estabelec.ins-estadual
          msg0042.Endereco              = tt-estabelec.endereco
          msg0042.Cidade                = tt-estabelec.cidade
          msg0042.UF                    = tt-estabelec.estado
          msg0042.CEP                   = string(tt-estabelec.cep)
          msg0042.Situacao              = IF AVAIL estabelec THEN 0 ELSE 1
          cabecalho.NumeroOperacao      = string(tt-estabelec.nome,"x(40)").
end.


/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
