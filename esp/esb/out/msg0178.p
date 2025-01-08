/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i alatur-cc 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: alatur-cc
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/
CREATE WIDGET-POOL.

{esp/esb/out/msg0178.i}.
{utp/ut-glob.i}

DEF INPUT PARAM TABLE FOR tt-tmp-integra-ccusto.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0178
   DATA-RELATION FOR conteudo, msg0178 RELATION-FIELDS (idm,  idm)  NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0178r, resultado
   DATA-RELATION FOR conteudor, msg0178r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0178r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF" /* Ver qual c¢digo deve ser informado neste campo */
       cabecalho.CodigoMensagem    = "MSG0178"
       cabecalho.LoginUsuario      = c-seg-usuario.

CREATE conteudo.

/* tt-tmp-integra-ccusto.i-ind-movto  */

FOR EACH tt-tmp-integra-ccusto: 

    CREATE msg0178.
    ASSIGN msg0178.CodigoCentroCusto    = tt-tmp-integra-ccusto.c-cod-ccusto
           msg0178.NomeCentroCusto      = SUBSTR(tt-tmp-integra-ccusto.c-nom-ccusto,1,32)
           msg0178.NomeEmpresa          = tt-tmp-integra-ccusto.c-cod-estab
           msg0178.Acao                 = tt-tmp-integra-ccusto.c-ind-movto
           msg0178.CodigoCentroCustoPai = ?
           cabecalho.NumeroOperacao     = SUBSTR(tt-tmp-integra-ccusto.c-cod-ccusto,4,5).
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

/* DEFINE VARIABLE hDoc AS HANDLE      NO-UNDO.                                                              */
/*                                                                                                           */
/* create x-document hDoc.                                                                                   */
/* hDoc:LOAD("longchar", oxml, NO).                                                                          */
/* hDoc:SAVE("file","C:/temp/alatur-cc-saida-" + /* replace(STRING(TIME, "HH:MM:SS"), ":", "") + */ ".xml"). */
/*                                                                                                           */
/*                                                                                                           */
/* create x-document hDoc.                                                                                   */
/* hDoc:LOAD("longchar", ixml, NO).                                                                          */
/* hDoc:SAVE("file","C:/temp/alatur-cc-ret-" + /* replace(STRING(TIME, "HH:MM:SS"), ":", "") + */ ".xml").   */

RETURN.
