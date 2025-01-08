/*****************************************************************************
** Programa: esp/acr/esacr039.p
** Vers∆o..: 1.00
** Data....: 14/09/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para importar o arquivo de Motivos Retorno (Layout 8.9)
*****************************************************************************/


/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pArquivo AS CHARACTER   NO-UNDO.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE c-linha    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont     AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esacr048 AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-seq      AS INTEGER     NO-UNDO.


/*--- Bloco Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Importando ParÉmetros Compra":U).


INPUT FROM VALUE(pArquivo) NO-ECHO CONVERT SOURCE "iso8859-1":U.
REPEAT:
    ASSIGN i-cont = i-cont + 1.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Importando Linha " + STRING(i-cont)).

    IMPORT UNFORMATTED c-linha.

    IF  NOT CAN-FIND(FIRST int-motivo-supcard NO-LOCK
                     WHERE int-motivo-supcard.cdn-motivo = SUBSTRING(c-linha, 1, 3)) THEN DO:
        FIND LAST int-motivo-supcard NO-LOCK NO-ERROR.

        ASSIGN i-seq = IF AVAILABLE int-motivo-supcard THEN int-motivo-supcard.cod-motivo + 1 ELSE 1.

        CREATE int-motivo-supcard.
        ASSIGN int-motivo-supcard.cod-motivo = i-seq
               int-motivo-supcard.des-motivo = SUBSTRING(c-linha, 4, 255)
               int-motivo-supcard.cdn-motivo = SUBSTRING(c-linha, 1, 3).
    END.
END.
INPUT CLOSE.


IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.


/* Copia o arquivo para a pasta de Antigos */
IF  NOT VALID-HANDLE(h-esacr048) THEN
    RUN esp/acr/esacr048.p PERSISTENT SET h-esacr048.

RUN pi-mover-arquivo IN h-esacr048 (INPUT pArquivo).
IF  RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

IF  VALID-HANDLE(h-esacr048) THEN DO:
    DELETE PROCEDURE h-esacr048.
    ASSIGN h-esacr048 = ?.
END.


IF  OPSYS = "WIN32":U THEN
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 15825,
                       INPUT "Processo de importaá∆o dos Motivos de Retorno (Layout 8.9) finalizado!":U).
