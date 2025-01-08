/*****************************************************************************
** Programa: esp/acr/esacr038.p
** Vers∆o..: 1.00
** Data....: 14/09/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para importar o arquivo de ParÉmetros de Compra (Layout 8.8)
*****************************************************************************/


/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pArquivo AS CHARACTER   NO-UNDO.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE c-linha      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esacr048   AS HANDLE      NO-UNDO.


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

    FIND LAST int-param-compra-supcard EXCLUSIVE-LOCK
         WHERE int-param-compra-supcard.dat-fatur   = DATE(INT(SUBSTRING(c-linha,14,2)),INT(SUBSTRING(c-linha,16,2)),INT(SUBSTRING(c-linha,10,4)))
         AND   int-param-compra-supcard.plano       = INT(SUBSTRING(c-linha,26,2))
         AND   int-param-compra-supcard.tp-cliente  = SUBSTRING(c-linha,60,5)
         AND   int-param-compra-supcard.dias-pagto  = INT(SUBSTRING(c-linha,53,2))
         AND   int-param-compra-supcard.dias-vencto = INT(SUBSTRING(c-linha,66,5)) 
         AND   int-param-compra-supcard.dias-flex   = INT(SUBSTRING(c-linha,95,5)) NO-ERROR.
    IF  NOT AVAIL int-param-compra-supcard THEN DO:
        CREATE int-param-compra-supcard.
        ASSIGN int-param-compra-supcard.dat-alteracao = TODAY
               int-param-compra-supcard.sequencia     = i-cont
               int-param-compra-supcard.dat-fatur     = DATE(INT(SUBSTRING(c-linha,14,2)),INT(SUBSTRING(c-linha,16,2)),INT(SUBSTRING(c-linha,10,4)))
               int-param-compra-supcard.plano         = INT(SUBSTRING(c-linha,26,2))
               int-param-compra-supcard.tp-cliente    = SUBSTRING(c-linha,60,5)
               int-param-compra-supcard.dias-pagto    = INT(SUBSTRING(c-linha,53,2))
               int-param-compra-supcard.dias-vencto   = INT(SUBSTRING(c-linha,66,5))
               int-param-compra-supcard.dias-flex     = INT(SUBSTRING(c-linha,95,5)).
    END.

    ASSIGN int-param-compra-supcard.dat-pri-vencto  = DATE(INT(SUBSTRING(c-linha,22,2)),INT(SUBSTRING(c-linha,24,2)),INT(SUBSTRING(c-linha,18,4)))
           int-param-compra-supcard.cond-financ     = SUBSTRING(c-linha,1,9)
           int-param-compra-supcard.coeficiente     = TRUNCATE(DEC(STRING(SUBSTRING(c-linha,28,10), "99,99999999")),8)
           int-param-compra-supcard.taxa            = TRUNCATE(DEC(STRING(SUBSTRING(c-linha,38,9), "999,999999")),6)
           int-param-compra-supcard.tp-pessoa       = INT(SUBSTRING(c-linha,59,1))
           int-param-compra-supcard.tp-oper         = INT(SUBSTRING(c-linha,65,1))
           int-param-compra-supcard.tax-antecipacao = TRUNCATE(DEC(STRING(SUBSTRING(c-linha,71,9), "999,999999")),6)
           int-param-compra-supcard.cod-empresa     = SUBSTRING(c-linha,80,2)
           int-param-compra-supcard.tax-cancel      = TRUNCATE(DEC(STRING(SUBSTRING(c-linha,82,6), "99,9999")),4)
           int-param-compra-supcard.tax-prorrog     = TRUNCATE(DEC(STRING(SUBSTRING(c-linha,88,6), "99,9999")),4)
           int-param-compra-supcard.nom-arquivo     = ENTRY(NUM-ENTRIES(pArquivo,"/"),pArquivo,"/")
           int-param-compra-supcard.dias-flex       = INT(SUBSTRING(c-linha,95,5)).
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
                       INPUT "Processo de importaá∆o dos ParÉmetros de Compra (Layout 8.8) finalizado!":U).
