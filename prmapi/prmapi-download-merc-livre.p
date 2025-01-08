/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte ‚ de propriedade exclusiva da PRIME Consultoria, sua reprodu‡Æo parcial ou total por qualquer meio, s¢ poder  ser feita mediante autoriza‡Æo expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: prmapi-download-merc-livre.p                                                                                                                         **
** Data .........: Setembro de 2021                                                                                                                                     **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: API para realizar o download das notas emitidas pelo Mercado Livre                                                                                   **
** Revisäes **************************************************************************************************************************************************************
** Autor           Ver.     Data         Cliente   Solicitante  Descri‡Æo                                                                                               **
** Pedro Vicari    00.001   21/09/2021   CRS       CRS          1) Desenvolvimento inicial do programa                                                                  **
** Willian Santana 00.002   30/01/2023   Thermoval Thermoval    2) No momento da integra‡Æo, estava retornando erro (429 too many Requests) pelo fato do Mercado livre  **
** limitar as os numeros de requisi‡äes. Inclui o m‚todo "PAUSE" com o tempo de cinco minutos, limitando as requisi‡äes e, os erros nÆo se apresentaram mais            **
*************************************************************************************************************************************************************************/

BLOCK-LEVEL ON ERROR UNDO,THROW.

{prmapi/PrmDownloadIntegrador.i}

/*--- Defini‡Æo Parƒmetros ---*/
DEFINE INPUT        PARAMETER p-cod-proj-int AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-log.

/*--- Variaveis Globais ---*/

/*--- Variaveis Locais ---*/
DEFINE VARIABLE h-acomp                 AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-tt-log                AS HANDLE                       NO-UNDO.
DEFINE VARIABLE prmDownloadMercLivre    AS prmapi.PrmDownloadMercLivre  NO-UNDO.

/*Inicio VERSÇO - 00.002*/
/*--- Inicio Execu‡Æo ---*/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp(INPUT "Download Mercado Livre...").

ASSIGN prmDownloadMercLivre = NEW prmapi.PrmDownloadMercLivre(INPUT p-cod-proj-int).

RUN pi-acompanhar IN h-acomp(INPUT "Autenticando").
prmDownloadMercLivre:getToken().

RUN pi-acompanhar IN h-acomp(INPUT "Download Notas de Venda").
/* PAUSE (300). */
prmDownloadMercLivre:getNotasVenda().

RUN pi-acompanhar IN h-acomp(INPUT "Download Notas de Remessa").
PAUSE (300).
prmDownloadMercLivre:getToken().
prmDownloadMercLivre:getNotasRemessa().
  
RUN pi-acompanhar IN h-acomp(INPUT "Download Notas de Retorno").
PAUSE (300).
prmDownloadMercLivre:getToken().
prmDownloadMercLivre:getNotasRetorno().
  
RUN pi-acompanhar IN h-acomp(INPUT "Download Notas de Devolu‡Æo").
PAUSE (300).
prmDownloadMercLivre:getToken().
prmDownloadMercLivre:getNotasDevolucao().

/*  
RUN pi-acompanhar IN h-acomp(INPUT "Download CT-e").
PAUSE (300).
prmDownloadMercLivre:getToken().
prmDownloadMercLivre:getCte().

  
PAUSE (300).
*/
/*FIM VERSÇO - 00.002*/

ASSIGN h-tt-log = prmDownloadMercLivre:getTTLog().
TEMP-TABLE tt-log:HANDLE:COPY-TEMP-TABLE(h-tt-log, TRUE).

CATCH erro AS Progress.Lang.Error:
    CREATE tt-log.
    ASSIGN tt-log.cod-proj-int = p-cod-proj-int
           tt-log.arquivo      = ""
           tt-log.tipo         = ""
           tt-log.msg          = SUBSTITUTE("(&1) &2", erro:GetMessageNum(1), erro:GetMessage(1)).
END CATCH.
FINALLY:
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END FINALLY.

/*------------------------------------------- Procedures Internas --------------------------------------------*/


