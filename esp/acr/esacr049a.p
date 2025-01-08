/*****************************************************************************
** Programa: esp/acr/esacr049a.p
** Vers∆o..: 1.00
** Data....: 20/12/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para replicar o £ltimo limite dos clientes para a data atual
*****************************************************************************/



/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE dt-avaliacao AS DATE        NO-UNDO.
DEFINE VARIABLE h-acomp      AS HANDLE      NO-UNDO.

DEFINE BUFFER bf-int-emitente-supcard FOR int-emitente-supcard.



/*--- Bloco Principal ---*/
ASSIGN dt-avaliacao = TODAY.

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Replicando Limites":U).


FOR EACH bf-int-emitente-supcard NO-LOCK
    BREAK BY bf-int-emitente-supcard.raiz-cnpj
          BY bf-int-emitente-supcard.dat-avaliacao:

    IF  LAST-OF(bf-int-emitente-supcard.raiz-cnpj)     AND
        LAST-OF(bf-int-emitente-supcard.dat-avaliacao) THEN DO:

        IF  NOT CAN-FIND(FIRST int-emitente-supcard NO-LOCK
                         WHERE int-emitente-supcard.raiz-cnpj     = bf-int-emitente-supcard.raiz-cnpj
                         AND   int-emitente-supcard.dat-avaliacao = dt-avaliacao) THEN DO:
            IF  VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Replicando limite: " + bf-int-emitente-supcard.raiz-cnpj).

            CREATE int-emitente-supcard.
            BUFFER-COPY bf-int-emitente-supcard EXCEPT dat-avaliacao TO int-emitente-supcard.
            ASSIGN int-emitente-supcard.dat-avaliacao = dt-avaliacao.
        END.
    END.
END.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.



IF  OPSYS = "WIN32":U THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 15825,
                       INPUT "Limites replicados com sucesso!":U).
END.

RETURN "OK":U.
