/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0092 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0092
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-ped-venda LIKE ped-venda.

{esp/esb/out/msg0092.i}
{utp/ut-glob.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-ped-venda.
RAW-TRANSFER raw-param TO tt-ped-venda.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0092
   DATA-RELATION FOR conteudo, msg0092 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0092r, resultado
   DATA-RELATION FOR conteudor, msg0092r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0092r, resultado RELATION-FIELDS (idm, idm) NESTED.
         
CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0092'.
     
CREATE conteudo.
CREATE msg0092.


FOR EACH tt-ped-venda NO-LOCK:
    ASSIGN cabecalho.NumeroOperacao = tt-ped-venda.nr-pedcli.
    FIND usuar_mestre
        WHERE Usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.
   ASSIGN msg0092.NumeroPedido       = tt-ped-venda.nr-pedcli
          msg0092.MotivoCancelamento = "Pedido Excluido atraves DO TOTVS - Usuario Cancelamento: " +  c-seg-usuario + " " + IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuar ELSE "".
   
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
