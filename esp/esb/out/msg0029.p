/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0029 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0029
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.
DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.

{esp/esb/out/msg0029.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEFINE TEMP-TABLE tt-fam-comerc  LIKE fam-comerc.

CREATE tt-fam-comerc.
RAW-TRANSFER raw-param TO tt-fam-comerc.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0029
   DATA-RELATION FOR conteudo, msg0029 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0029r, resultado
   DATA-RELATION FOR conteudor, msg0029r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0029r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0029'.
     
CREATE conteudo.
CREATE msg0029.

FOR EACH tt-fam-comerc NO-LOCK:

    IF SUBSTRING(tt-fam-comerc.fm-cod-com,1,2) = "99" THEN
        RETURN.

    ASSIGN msg0029.CodigoFamilia    = tt-fam-comerc.fm-cod-com
           cabecalho.NumeroOperacao = tt-fam-comerc.fm-cod-com.  
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
