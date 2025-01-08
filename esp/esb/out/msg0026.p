/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0026 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0026
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-fam-com-item LIKE fam-com-item.

{esp/esb/out/msg0026.i}
{esp/es0018.i}

RUN esp/es0018p.p (INPUT "boes513", /* Nome do programa */
                   INPUT 1,         /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-fam-com-item.
RAW-TRANSFER raw-param TO tt-fam-com-item.

FIND FIRST fam-com-item OF tt-fam-com-item NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0026
   DATA-RELATION FOR conteudo, msg0026 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0026r, resultado
   DATA-RELATION FOR conteudor, msg0026r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0026r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0026'.
     
CREATE conteudo.
CREATE msg0026.

FOR FIRST tt-fam-com-item NO-LOCK:

/*     IF tt-fam-com-item.unidade = "99" THEN */ /* Conforme chamado 58053 */
/*         RETURN. */

    FIND FIRST tt-prog-ponto 
         WHERE tt-prog-ponto.sequencia = int(tt-fam-com-item.unidade) NO-ERROR.

   FIND FIRST unid_negoc NO-LOCK
        WHERE unid_negoc.cdn_unid_negoc = int(tt-prog-ponto.conteudo) NO-ERROR.

/*    IF NOT AVAIL unid_negoc THEN */
/*        RETURN "NOK":U. */
/*    */
   ASSIGN msg0026.CodigoSegmento     = tt-fam-com-item.unidade + tt-fam-com-item.segmento
          msg0026.Nome               = tt-fam-com-item.descricao
          msg0026.UnidadeNegocio     = if not avail unid_negoc then "ADM" else unid_negoc.cod_unid_negoc
          msg0026.QuantidadeShowRoom = 0
          msg0026.Situacao           = IF AVAIL fam-com-item THEN 0 ELSE 1 
          cabecalho.NumeroOperacao   = string(tt-fam-com-item.descricao,"x(40)").
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
