/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0002 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0002
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/
CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-unid-negoc LIKE unid-negoc.

{esp/esb/out/msg0002.i}.

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-unid-negoc.
RAW-TRANSFER raw-param TO tt-unid-negoc.

FIND FIRST unid-negoc OF tt-unid-negoc NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0002
   DATA-RELATION FOR conteudo, msg0002 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0002r, resultado
   DATA-RELATION FOR conteudor, msg0002r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0002r, resultado RELATION-FIELDS (idm, idm) NESTED.
                                                   
CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0002'.
     
CREATE conteudo.
CREATE msg0002.



FOR EACH tt-unid-negoc NO-LOCK:
    ASSIGN msg0002.CodigoUnidadeNegocio = tt-unid-negoc.cod-unid-negoc
           msg0002.Nome                 = tt-unid-negoc.des-unid-negoc
           msg0002.Situacao             = IF AVAIL unid-negoc THEN 0 ELSE 1
           cabecalho.NumeroOperacao     = tt-unid-negoc.cod-unid-negoc
        .
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
