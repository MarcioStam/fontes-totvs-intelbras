/*****************************************************************************
** Programa: esp/acr/esacr044.p
** Vers∆o..: 1.00
** Data....: 05/10/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para Ler os arquivos de Retorno das transaá‰es com o SupplierCard,
**           de acordo com o layout enviado (Layout 8.3).
*****************************************************************************/


/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pArquivo AS CHARACTER   NO-UNDO.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE c-linha             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-raiz-cnpj         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-des-motivo        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-arquivo          AS DATE        NO-UNDO.
DEFINE VARIABLE i-cont              AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq               AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-dias-atraso-intel AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-classe        AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-val-limite       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE h-acomp             AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esacr048          AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD num-transac AS CHARACTER FORMAT "x(14)"
    FIELD cdn-motivo  AS CHARACTER FORMAT "x(3)"
    FIELD des-motivo  AS CHARACTER FORMAT "x(100)".

/* ************************  Function Prototypes ********************** */

FUNCTION fnMotivo RETURNS INTEGER
  ( pCdnMotivo AS CHARACTER )  FORWARD.

/*--- Bloco Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Importando dados":U).


INPUT FROM VALUE(pArquivo) NO-ECHO CONVERT SOURCE "iso8859-1":U.
REPEAT:
    ASSIGN i-cont = i-cont + 1.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Importando Linha " + STRING(i-cont)).

    IMPORT UNFORMATTED c-linha.


    /* HEADER */
    IF  SUBSTRING(c-linha,1,1) = "0" THEN DO:
        ASSIGN dt-arquivo = DATE(SUBSTRING(c-linha,12,8)).
    END.

    
    /* DETALHE */
    IF  SUBSTRING(c-linha,1,1) = "1" THEN DO:
        ASSIGN c-raiz-cnpj = SUBSTRING(c-linha,6,8).

        /* Busca a £ltima informaá∆o dos Dias de Atraso Intelbras, para o cliente */
        FIND LAST int-emitente-supcard NO-LOCK
            WHERE int-emitente-supcard.raiz-cnpj = c-raiz-cnpj NO-ERROR.
        IF  AVAIL int-emitente-supcard THEN
            ASSIGN i-dias-atraso-intel = int-emitente-supcard.qtd-dias-atraso-int
                   i-cod-classe        = int-emitente-supcard.cod-classe
                   de-val-limite       = int-emitente-supcard.val-limite.
    
        FIND FIRST int-emitente-supcard EXCLUSIVE-LOCK
            WHERE  int-emitente-supcard.raiz-cnpj     = c-raiz-cnpj
            AND    int-emitente-supcard.dat-avaliacao = dt-arquivo NO-ERROR.
        IF  NOT AVAIL int-emitente-supcard THEN DO:
            CREATE int-emitente-supcard.
            ASSIGN int-emitente-supcard.raiz-cnpj           = c-raiz-cnpj
                   int-emitente-supcard.dat-avaliacao       = dt-arquivo
                   int-emitente-supcard.qtd-dias-atraso-int = i-dias-atraso-intel
                   int-emitente-supcard.cod-classe          = i-cod-classe.
        END.
        ELSE
            ASSIGN de-val-limite = int-emitente-supcard.val-limite.
    
        ASSIGN int-emitente-supcard.log-habilitado       = int-emitente-supcard.log-habilitado
               int-emitente-supcard.val-limite           = de-val-limite
               int-emitente-supcard.val-limite-utilizado = int-emitente-supcard.val-limite-utilizado
               int-emitente-supcard.qtd-dias-atraso-sc   = int-emitente-supcard.qtd-dias-atraso-sc.
    
    
        FIND LAST int-emitente-supcard-ocor NO-LOCK
            WHERE int-emitente-supcard-ocor.raiz-cnpj = c-raiz-cnpj NO-ERROR.
        IF  AVAIL int-emitente-supcard-ocor THEN
            ASSIGN i-seq = int-emitente-supcard-ocor.seq-avaliacao + 1.

        CREATE int-emitente-supcard-ocor.
        ASSIGN int-emitente-supcard-ocor.raiz-cnpj            = c-raiz-cnpj
               int-emitente-supcard-ocor.seq-avaliacao        = i-seq
               int-emitente-supcard-ocor.cod-usuar            = c-seg-usuario
               int-emitente-supcard-ocor.dat-avaliacao        = dt-arquivo
               int-emitente-supcard-ocor.cod-motivo           = fnMotivo(SUBSTRING(c-linha,450,3))
               int-emitente-supcard-ocor.num-transac          = SUBSTRING(c-linha,85,14)
               int-emitente-supcard-ocor.num-parcela          = SUBSTRING(c-linha,129,2)
               int-emitente-supcard-ocor.obs                  = SUBSTRING(c-linha,307,100)
               int-emitente-supcard-ocor.ind-env-ret          = 2 /* Retorno */
               int-emitente-supcard-ocor.ind-ocor             = "8.3"
               int-emitente-supcard-ocor.log-emergencial      = NO
               int-emitente-supcard-ocor.log-habilitado       = IF SUBSTRING(c-linha,448,2) = "03" /* Rejeitada */ THEN NO ELSE YES
               int-emitente-supcard-ocor.qtd-dias-atraso      = 0
               int-emitente-supcard-ocor.val-limite           = 0
               int-emitente-supcard-ocor.val-limite-sugerido  = 0
               int-emitente-supcard-ocor.val-limite-utilizado = 0
               int-emitente-supcard-ocor.nom-arquivo          = ENTRY(NUM-ENTRIES(pArquivo,"/"),pArquivo,"/").

        IF  NOT int-emitente-supcard-ocor.log-habilitado THEN DO:
            FIND FIRST int-motivo-supcard NO-LOCK
                WHERE  int-motivo-supcard.cod-motivo = int-emitente-supcard-ocor.cod-motivo NO-ERROR.
            ASSIGN c-des-motivo = IF AVAIL int-motivo-supcard THEN int-motivo-supcard.des-motivo ELSE "Motivo n∆o localizado!".
            CREATE tt-erro.
            ASSIGN tt-erro.num-transac = int-emitente-supcard-ocor.num-transac
                   tt-erro.cdn-motivo  = SUBSTRING(c-linha, 450, 3)
                   tt-erro.des-motivo  = c-des-motivo.
        END.
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


/* Verifica se tiveram rejeiá‰es para as transaá‰es enviadas, e exporta para um arquivo. */
IF  CAN-FIND(FIRST tt-erro) THEN DO:
    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "ErrosSupplierCard.txt".
    OUTPUT TO VALUE(c-arquivo) NO-CONVERT.

    PUT UNFORMATTED FILL("-", 124) SKIP
                    FILL(" ", 44) + "Transaá‰es Rejeitadas pela SupplierCard" SKIP
                    FILL("-", 124) SKIP(2)
                    "Transaá∆o" + FILL(" ", 7) + "Motivo"  SKIP
                    FILL("-", 15) + " " + FILL("-", 108) SKIP.

    FOR EACH tt-erro NO-LOCK:
        PUT UNFORMATTED tt-erro.num-transac + "  "
                        tt-erro.cdn-motivo + " - " + tt-erro.des-motivo SKIP.
    END.
    OUTPUT CLOSE.

    IF  OPSYS = "WIN32":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Transaá‰es rejeitadas pela SupplierCard.~~":U + 
                                 "O processo de importaá∆o Upload de Compras (Layout 8.3) foi finalizado, mas contÇm rejeiá‰es. ":U).
    
        RUN WinExec (INPUT "Notepad.exe":U + CHR(32) + c-arquivo,
                     INPUT 1).
    END.
END.
ELSE DO:
    IF  OPSYS = "WIN32":U THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Processo de importaá∆o Upload de Compras (Layout 8.3) finalizado!":U).
END.



/*--- Procedure Internas ---*/
PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
    DEF INPUT  PARAM prg_name   AS CHARACTER.
    DEF INPUT  PARAM prg_style  AS SHORT.
END PROCEDURE.

/* ************************  Function Implementations ***************** */

FUNCTION fnMotivo RETURNS INTEGER
  ( pCdnMotivo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST int-motivo-supcard
        WHERE int-motivo-supcard.cdn-motivo = pCdnMotivo NO-LOCK NO-ERROR.

    IF AVAILABLE int-motivo-supcard THEN
        RETURN int-motivo-supcard.cod-motivo.
    ELSE
        RETURN 0.

END FUNCTION.

