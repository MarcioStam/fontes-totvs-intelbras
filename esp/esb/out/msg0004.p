/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0004 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0004
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-cond-pagto LIKE cond-pagto.

{esp/esb/out/msg0004.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

CREATE tt-cond-pagto.
RAW-TRANSFER raw-param TO tt-cond-pagto.
FIND FIRST cond-pagto OF tt-cond-pagto NO-LOCK NO-ERROR.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0004
   DATA-RELATION FOR conteudo, msg0004 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0004r, resultado
   DATA-RELATION FOR conteudor, msg0004r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0004r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0004'.
     
CREATE conteudo.
CREATE msg0004.

DEFINE VARIABLE c-ChaveIntegracaoIndice AS CHARACTER FORMAT 'x(50)'  NO-UNDO.

FOR EACH tt-cond-pagto NO-LOCK:

/*     IF tt-cond-pagto.nr-tab-finan = 20 THEN                                                    */
/*     MESSAGE string(tt-cond-pagto.nr-tab-finan) + ";" + string(tt-cond-pagto.nr-ind-finan) SKIP */
/*             c-ChaveIntegracaoIndice                                                            */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                     */
    
    ASSIGN c-ChaveIntegracaoIndice            = string(tt-cond-pagto.nr-tab-finan)
           c-ChaveIntegracaoIndice            = c-ChaveIntegracaoIndice + ";"
           c-ChaveIntegracaoIndice            = c-ChaveIntegracaoIndice + string(tt-cond-pagto.nr-ind-finan)
           msg0004.CodigoCondicaoPagamento    = tt-cond-pagto.cod-cond-pag
           msg0004.Nome                       = tt-cond-pagto.descricao 
           msg0004.NumeroParcelas             = tt-cond-pagto.num-parcelas
           msg0004.PercentualDesconto         = tt-cond-pagto.per-des-pgan
           msg0004.Prazo                      = 0
           cabecalho.NumeroOperacao           = STRING(tt-cond-pagto.descricao,"x(40)")
           msg0004.NumeroTabelaFinanciamento  = string(tt-cond-pagto.nr-tab-finan)
           msg0004.ChaveIntegracaoIndice      = c-ChaveIntegracaoIndice.
           

/*     IF tt-cond-pagto.nr-tab-finan = 20 THEN DO:                                                    */
/*         MESSAGE string(tt-cond-pagto.nr-tab-finan) + ";" + string(tt-cond-pagto.nr-ind-finan) SKIP */
/*                 c-ChaveIntegracaoIndice                                                            */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                     */
/*         PAUSE 2.                                                                                   */
/*     END.                                                                                           */

    FOR FIRST int-cond-pagto
        WHERE int-cond-pagto.cod-cond-pag = tt-cond-pagto.cod-cond-pag NO-LOCK:
          IF AVAILABLE int-cond-pagto THEN DO:
              ASSIGN msg0004.UtilizadoCanais            = IF SUBSTRING(int-cond-pagto.char-1,6,1)  = "S" THEN YES ELSE NO
                     msg0004.UtilizadoFornecedores      = IF SUBSTRING(int-cond-pagto.char-1,9,1)  = "S" THEN YES ELSE NO
                     msg0004.UtilizadoB2B               = IF SUBSTRING(int-cond-pagto.char-1,7,1)  = "S" THEN YES ELSE NO
                     msg0004.UtilizadoSDCV              = int-cond-pagto.log-sdcv
                     msg0004.SupplierCard               = IF SUBSTRING(int-cond-pagto.char-1,4,1)  = 'S' THEN YES ELSE NO
                     msg0004.UtilizadoRevenda           = IF SUBSTRING(int-cond-pagto.char-1,10,1) = 'S' THEN YES ELSE NO
                     msg0004.CondicaoFFT                = int-cond-pagto.log-controla-fft.
          END.
    END.
end.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
