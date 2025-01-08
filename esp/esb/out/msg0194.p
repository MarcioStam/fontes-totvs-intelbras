/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0194 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: msg0194
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-crm-relacionamento-cliente LIKE crm-relacionamento-cliente
    FIELD situacao AS INTEGER.

{esp/esb/out/msg0194.i}
{esp/esb/esesb000.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEF VAR c-identificador AS CHAR NO-UNDO.

CREATE tt-crm-relacionamento-cliente.
RAW-TRANSFER raw-param TO tt-crm-relacionamento-cliente.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0194
   DATA-RELATION FOR conteudo, msg0194 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0194r, resultado
   DATA-RELATION FOR conteudor, msg0194r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0194r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0194'.
     
CREATE conteudo.
CREATE msg0194.

FOR FIRST tt-crm-relacionamento-cliente NO-LOCK:
    ASSIGN cabecalho.NumeroOperacao = string(tt-crm-relacionamento-cliente.cod-emitente) + " / " + STRING(tt-crm-relacionamento-cliente.seq).

    FIND FIRST unid-comerc NO-LOCK
        WHERE  unid-comerc.cd-unid-comerc = INT(tt-crm-relacionamento-cliente.cd-unid-negoc) NO-ERROR.
    IF  NOT AVAIL unid-comer THEN
        RETURN "NOK".

    FIND emitente NO-LOCK
        WHERE emitente.cod-emitente = tt-crm-relacionamento-cliente.cod-emitente NO-ERROR.
    IF  NOT AVAIL emitente THEN
        RETURN "NOK".

    ASSIGN msg0194.CodigoRelacionamentoB2B = string(tt-crm-relacionamento-cliente.cod-emitente) + "," + STRING(tt-crm-relacionamento-cliente.seq)
           msg0194.NomeRelacionamento      = unid-comerc.ds-unid-comerc
           msg0194.CodigoCategoriaB2B      = tt-crm-relacionamento-cliente.cd-categoria
           msg0194.CodigoCliente           = tt-crm-relacionamento-cliente.cod-emitente
           msg0194.CodigoGrupoCliente      = emitente.cod-gr-cli
           msg0194.CodigoRepresentante     = tt-crm-relacionamento-cliente.cod-rep.

    ASSIGN msg0194.NomeUnidadeComercial  = unid-comerc.ds-unid-comerc
           msg0194.Sequencia               = tt-crm-relacionamento-cliente.seq
           msg0194.DataInicial             = tt-crm-relacionamento-cliente.dt-vigencia-ini
           msg0194.DataFinal               = tt-crm-relacionamento-cliente.dt-vigencia-fim
           msg0194.Situacao                = tt-crm-relacionamento-cliente.situacao.

    IF  tt-crm-relacionamento-cliente.observacao <> "" THEN
        ASSIGN msg0194.mensagem                = tt-crm-relacionamento-cliente.observacao.
    ELSE
        ASSIGN msg0194.mensagem                = ?.
end.



/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN "OK".
