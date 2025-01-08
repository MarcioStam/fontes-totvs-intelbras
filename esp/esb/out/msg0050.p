/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0050 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0050
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

define temp-table tt-natur-oper like natur-oper.

{esp/esb/out/msg0050.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-natur-oper.
raw-transfer raw-param to tt-natur-oper.

FIND FIRST natur-oper OF tt-natur-oper NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0050
   data-relation for conteudo, msg0050 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0050r, resultado
   data-relation for conteudor, msg0050r relation-fields (idm, idm) nested
   data-relation for msg0050r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0050'.
     
create conteudo.
create msg0050.

for first tt-natur-oper no-lock:
    assign msg0050.CodigoNaturezaOperacao = tt-natur-oper.nat-operacao
           msg0050.Nome                   = tt-natur-oper.denominacao.

           IF tt-natur-oper.tipo = 1 THEN
               ASSIGN msg0050.Tipo = 993520000.
           ELSE IF tt-natur-oper.tipo = 2 THEN
               ASSIGN msg0050.Tipo = 993520001.
           ELSE IF tt-natur-oper.tipo = 3 THEN
               ASSIGN msg0050.Tipo = 993520002.

           if tt-natur-oper.nat-ativa = NO
              OR NOT AVAIL natur-oper then
              assign msg0050.Situacao = 1.
           else 
              assign msg0050.Situacao = 0.
    
    assign cabecalho.NumeroOperacao    = string(tt-natur-oper.denominacao,"x(40)")
           msg0050.AtualizaEstatistica = tt-natur-oper.atual-estat
           msg0050.EmiteDuplicata      = tt-natur-oper.emite-duplic.
end.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
