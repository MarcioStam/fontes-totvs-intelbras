/*****************************************************************************
** Programa: esp/acr/esacr046.p
** Vers∆o..: 1.00
** Data....: 18/10/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para ler o arquivo de Agendamento de Pagamentos, de acordo
**           com o layout enviado (Layout 8.7).
*****************************************************************************/


/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pArquivo   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pDtArquivo AS DATE        NO-UNDO.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE c-linha      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-raiz-cnpj  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sinal      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-arquivo   AS DATE        NO-UNDO.
DEFINE VARIABLE i-cont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-id-pagto   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-id-ocor    AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esacr048   AS HANDLE      NO-UNDO.


/*--- Bloco Principal ---*/
/* Valida se o arquivo j† foi importado */
IF  CAN-FIND(FIRST int-pagtos-supcard NO-LOCK
             WHERE int-pagtos-supcard.nom-arquivo = ENTRY(NUM-ENTRIES(pArquivo,"/"),pArquivo,"/")) THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Arquivo de Pagamento (" + ENTRY(NUM-ENTRIES(pArquivo,"/"),pArquivo,"/") + " ) j† foi processado!":U).
    END.

    RETURN "NOK":U.
END.


IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Importando dados":U).


/* Busca o £ltimo ID */
FIND LAST int-pagtos-supcard NO-LOCK NO-ERROR.
ASSIGN i-id-pagto = IF AVAIL int-pagtos-supcard THEN int-pagtos-supcard.id-pagto ELSE 0.


INPUT FROM VALUE(pArquivo) NO-ECHO CONVERT SOURCE "iso8859-1":U.
REPEAT:
    ASSIGN i-cont = i-cont + 1.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Importando Linha " + STRING(i-cont)).

    IMPORT UNFORMATTED c-linha.


    /* HEADER */
    IF  SUBSTRING(c-linha,1,1) = "0" THEN DO:
        ASSIGN dt-arquivo = DATE(INT(SUBSTRING(c-linha,6,2)),INT(SUBSTRING(c-linha,8,2)),INT(SUBSTRING(c-linha,2,4))).
    END.

    
    /* DETALHE 1 */
    IF  SUBSTRING(c-linha,1,1) = "1" THEN DO:
        ASSIGN c-raiz-cnpj = SUBSTRING(c-linha,6,8).

        ASSIGN i-id-pagto  = i-id-pagto + 1
               i-id-ocor   = 0.

        CREATE int-pagtos-supcard.
        ASSIGN int-pagtos-supcard.id-pagto      = i-id-pagto
               int-pagtos-supcard.dat-alteracao = pDtArquivo
               int-pagtos-supcard.dat-pagto     = DATE(INT(SUBSTRING(c-linha,12,2)),INT(SUBSTRING(c-linha,14,2)),INT(SUBSTRING(c-linha,8,4)))
               int-pagtos-supcard.num-bordero   = SUBSTRING(c-linha,16,6)
               int-pagtos-supcard.cod-banco     = INT(SUBSTRING(c-linha,74,3))
               int-pagtos-supcard.cod-agencia   = SUBSTRING(c-linha,77,9)
               int-pagtos-supcard.cod-conta     = SUBSTRING(c-linha,86,20)
               int-pagtos-supcard.historico     = SUBSTRING(c-linha,106,100)
               int-pagtos-supcard.cod-evento    = SUBSTRING(c-linha,206,7)
               int-pagtos-supcard.nom-arquivo   = ENTRY(NUM-ENTRIES(pArquivo,"/"),pArquivo,"/").

        /* Concatena o Sinal com o valor, para que caso seja negativo o valor fique negativo */
        ASSIGN int-pagtos-supcard.val-pagto = TRUNCATE(DEC(STRING(SUBSTRING(c-linha,22,12),"9999999999,99")),2)
               c-sinal                      = SUBSTRING(c-linha,22,1).

        /* Verifica se o pagamento Ç futuro */
        IF  int-pagtos-supcard.dat-pagto > pDtArquivo THEN
            ASSIGN int-pagtos-supcard.log-lancto-futuro = YES.
        ELSE DO:
            /* Se n∆o for um lanáamento futuro e o evento for de "Saldo Negativo", cria uma
               ocorrància porque para este tipo de evento n∆o Ç enviada a ocorrància no arquivo */
            IF  int-pagtos-supcard.cod-evento = "SLDAN" THEN DO:
                ASSIGN i-id-ocor = i-id-ocor + 1.
                CREATE int-pagtos-supcard-ocor.
                ASSIGN int-pagtos-supcard-ocor.id-pagto             = i-id-pagto
                       int-pagtos-supcard-ocor.id-ocor              = i-id-ocor
                       int-pagtos-supcard-ocor.cnpj                 = ""
                       int-pagtos-supcard-ocor.num-cartao           = ""
                       int-pagtos-supcard-ocor.num-transac          = ""
                       int-pagtos-supcard-ocor.qtd-tot-parcelas     = 1
                       int-pagtos-supcard-ocor.num-parcela          = 1
                       int-pagtos-supcard-ocor.val-compra           = 0
                       int-pagtos-supcard-ocor.val-parcela          = 0
                       int-pagtos-supcard-ocor.log-pagto-antecipado = NO
                       int-pagtos-supcard-ocor.dat-vencto-parcela   = int-pagtos-supcard.dat-pagto
                       int-pagtos-supcard-ocor.num-bordero          = int-pagtos-supcard.num-bordero
                       int-pagtos-supcard-ocor.val-lancamento       = int-pagtos-supcard.val-pagto.
            END.
        END.
    END.


    /* DETALHE 2 */
    IF  SUBSTRING(c-linha,1,1) = "2" THEN DO:
        ASSIGN i-id-ocor = i-id-ocor + 1.

        CREATE int-pagtos-supcard-ocor.
        ASSIGN int-pagtos-supcard-ocor.id-pagto             = i-id-pagto
               int-pagtos-supcard-ocor.id-ocor              = i-id-ocor
               int-pagtos-supcard-ocor.cnpj                 = SUBSTRING(c-linha,2,14)
               int-pagtos-supcard-ocor.num-cartao           = SUBSTRING(c-linha,16,16)
               int-pagtos-supcard-ocor.num-transac          = SUBSTRING(c-linha,40,14)
               int-pagtos-supcard-ocor.qtd-tot-parcelas     = INT(SUBSTRING(c-linha,54,2))
               int-pagtos-supcard-ocor.num-parcela          = INT(SUBSTRING(c-linha,56,2))
               int-pagtos-supcard-ocor.val-compra           = TRUNCATE(DEC(STRING(SUBSTRING(c-linha,58,11),"999999999,99")),2)
               int-pagtos-supcard-ocor.val-parcela          = TRUNCATE(DEC(STRING(SUBSTRING(c-linha,69,11),"999999999,99")),2)
               int-pagtos-supcard-ocor.log-pagto-antecipado = IF SUBSTRING(c-linha,80,1) = "1" THEN YES ELSE NO
               int-pagtos-supcard-ocor.dat-vencto-parcela   = DATE(INT(SUBSTRING(c-linha,85,2)),INT(SUBSTRING(c-linha,87,2)),INT(SUBSTRING(c-linha,81,4)))
               int-pagtos-supcard-ocor.num-bordero          = SUBSTRING(c-linha,100,6)
               int-pagtos-supcard-ocor.val-lancamento       = TRUNCATE(DEC(STRING(c-sinal + SUBSTRING(c-linha,106,11),"9999999999,99")),2).

        /* Se o pagamento foi do total do t°tulo, a parcela vem zerada e por isso deve ser a 1a parcela */
        IF  int-pagtos-supcard-ocor.num-parcela = 0 THEN
            ASSIGN int-pagtos-supcard-ocor.num-parcela = 1.
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


IF  OPSYS = "WIN32":U THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 15825,
                       INPUT "Processo de importaá∆o do Agendamento de Pagamentos (Layout 8.7) finalizado!":U).
END.

RETURN "OK":U.
