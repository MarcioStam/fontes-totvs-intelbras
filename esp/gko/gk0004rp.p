/*------------------------------------------------------------------------
    File        : GK0004RP.P
    Purpose     : Importaá∆o Contabilizaá∆o GKO
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Junho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/
{include/i-prgvrs.i GK0004RP 2.00.00.000}

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{esp/gko/gk0004.i}   /* Definiá∆o das temp-tables dos programas */
{esp/gko/gkapi001.i} /* Definiá∆o temp-table "tt-log-gko" */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-arquivo NO-UNDO
    FIELD nom-arquivo      AS CHARACTER
    FIELD nom-completo     AS CHARACTER
    FIELD ind-tipo-arquivo AS CHARACTER.

DEFINE TEMP-TABLE tt-linha-arquivo NO-UNDO
    FIELD nome-arquivo   AS CHARACTER
    FIELD numero-linha   AS INTEGER
    FIELD conteudo-linha AS CHARACTER
    INDEX chNomeArqLinha AS PRIMARY UNIQUE
        nome-arquivo
        numero-linha.

DEFINE TEMP-TABLE tt-transportador NO-UNDO
    FIELD cod-transportador     AS INTEGER   FORMAT ">>>,>>>,>>9":U                LABEL "Transportador":U        COLUMN-LABEL "Transp":U
    FIELD cod-estab             AS CHARACTER FORMAT "x(3)":U                       LABEL "Estabelecimento":U      COLUMN-LABEL "Estab":U
    FIELD cod-cta-ctbl          AS CHARACTER FORMAT "x(20)":U                      LABEL "Conta Cont†bil":U       COLUMN-LABEL "Conta Cont†bil":U
    FIELD cdn-unid-negoc        AS INTEGER   FORMAT ">>>>>>9":U                    LABEL "N£mero Unidade Negoc":U COLUMN-LABEL "N£mero UN":U
    FIELD cod-ccusto            AS CHARACTER FORMAT "x(11)":U                      LABEL "Centro Custo":U         COLUMN-LABEL "Centro Custo":U
    FIELD ind-natur-lancto-ctbl AS CHARACTER FORMAT "x(2)":U                       LABEL "Natureza":U             COLUMN-LABEL "Natureza":U
    FIELD cod-lote-gko          AS CHAR      FORMAT "x(20)"                        LABEL "Lote GKO"               COLUMN-LABEL "Lote GKO"
    FIELD nom-completo          AS CHARACTER FORMAT "x(100)":U                     LABEL "Nome Completo":U        COLUMN-LABEL "Nome Completo":U
    FIELD nom-arquivo           AS CHARACTER FORMAT "x(100)":U                     LABEL "Nome Arquivo":U         COLUMN-LABEL "Arquivo":U
    FIELD vl-lancamento         AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 LABEL "Valor Lanáamento":U     COLUMN-LABEL "Valor Lanáamento":U
    INDEX id IS PRIMARY UNIQUE
        cod-transportador
        cod-estab
        cod-cta-ctbl
        cdn-unid-negoc
        cod-ccusto
        ind-natur-lancto-ctbl
        cod-lote-gko
        nom-completo.

DEFINE TEMP-TABLE tt-log-erros NO-UNDO
    FIELD cdn-transportador     AS INTEGER   FORMAT ">>>,>>>,>>9":U
    FIELD cod-estab             AS CHARACTER FORMAT "x(3)":U
    FIELD cod-cta-ctbl          AS CHARACTER FORMAT "x(20)":U
    FIELD cdn-unid-negoc        AS INTEGER   FORMAT ">>>>>>9":U
    FIELD cod-ccusto            AS CHARACTER FORMAT "x(11)":U
    FIELD ind-natur-lancto-ctbl AS CHARACTER FORMAT "x(2)":U
    FIELD cod-lote-gko          AS CHAR      FORMAT "x(20)"
    FIELD nom-completo          AS CHARACTER FORMAT "x(100)":U
    FIELD nom-arquivo           AS CHARACTER FORMAT "x(100)":U
    FIELD num-mensagem          AS INTEGER   FORMAT ">>>>,>>9":U
    FIELD des-msg-erro          AS CHARACTER FORMAT "x(60)":U
    FIELD des-msg-ajuda         AS CHARACTER FORMAT "x(40)":U.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp                 AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-dir-destino           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-transportador     AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-cod-estabel           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cdn-unid-negoc        AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-cod-ccusto            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-ind-natur-lancto-ctbl AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-lote-gko          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-vl-lancamento         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-connected AS LOGICAL     NO-UNDO.

/* Local Stream Definitions ---                                         */

DEFINE STREAM str-in.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ************************  Function Prototypes ********************** */

FUNCTION fn-conv-deci RETURNS DECIMAL
  ( p-num AS CHARACTER, p-decimals AS INTEGER )  FORWARD.

FUNCTION fn-conv-data RETURNS DATE
  ( p-data AS CHARACTER )  FORWARD.

FUNCTION fn-conv-logi RETURNS LOGICAL
  ( p-logical AS CHARACTER )  FORWARD.

FUNCTION fn-conv-inte RETURNS INTEGER
  ( p-num AS CHARACTER )  FORWARD.


/* ***************************  Main Block  *************************** */

FIND LAST param-global NO-LOCK NO-ERROR.

ASSIGN l-connected = CONNECTED("EMS5":U).

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "").

RUN pi-importar-fatura IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

IF RETURN-VALUE = "NOK":U THEN DO:
    RUN esp/gko/gkapi001.p (INPUT TABLE tt-log-gko).

    RETURN "NOK":U.
END.
ELSE
    RUN esp/gko/gkapi001.p (INPUT TABLE tt-log-gko).

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-importar-fatura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE conteudo      AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-log-gko.

    /* Buscar arquivo(s) para importaá∆o das faturas GKO */
    RUN pi-carrega-linha-arq IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    EMPTY TEMP-TABLE tt-transportador.
    EMPTY TEMP-TABLE tt-log-erros.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Carregando campos registros...":U).

    /*bk-arquivo:*/
    FOR EACH tt-arquivo:

        bk-linha-arquivo:
        FOR EACH tt-linha-arquivo
            WHERE tt-linha-arquivo.nome-arquivo = tt-arquivo.nom-completo:

            ASSIGN conteudo = tt-linha-arquivo.conteudo-linha.

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Arquivo: ":U + TRIM(tt-arquivo.nom-arquivo) + " - Registro: ":U + TRIM(SUBSTRING(conteudo, 1, 3))).

            CASE SUBSTRING(conteudo, 1, 3):
                /* Registro 070 - Lanáamento Cont†bil (Cabeáalho) */
                WHEN "070":U THEN DO:
                    ASSIGN v-cod-transportador = 0
                           v-cod-estabel       = "":U.

                    FIND FIRST estabelec
                        WHERE estabelec.cod-emitente = fn-conv-inte(TRIM(SUBSTRING(conteudo, 51, 15))) NO-LOCK NO-ERROR.

                    IF NOT AVAILABLE estabelec THEN DO:
                        CREATE tt-log-gko.
                        ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                               tt-log-gko.log-imp-erro           = YES
                               tt-log-gko.ind-tipo-integracao    = 4
                               tt-log-gko.des-erro-imp           = "Companhia n∆o encontrada com o c¢digo informado. C¢digo: ":U + TRIM(SUBSTRING(conteudo, 51, 15)) + " (Linha ":U + TRIM(STRING(tt-linha-arquivo.numero-linha)) + ")":U.

                        NEXT bk-linha-arquivo.
                    END.

                    ASSIGN v-cod-transportador = fn-conv-inte(TRIM(SUBSTRING(conteudo, 21, 14)))
                           v-cod-estabel       = estabelec.cod-estabel.
                END. /* WHEN "070":U THEN DO: */

                /* Registro 075 - Lanáamento Cont†bil (Detalhe) */
                WHEN "075":U THEN DO:
                    IF v-cod-transportador = 0    OR
                       v-cod-estabel       = "":U THEN DO:
                        CREATE tt-log-gko.
                        ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                               tt-log-gko.log-imp-erro           = YES
                               tt-log-gko.ind-tipo-integracao    = 4
                               tt-log-gko.des-erro-imp           = "Registro 070 n∆o encontrado para o registro 075.":U + CHR(10) + CHR(10) + "Linha: ":U + TRIM(STRING(tt-linha-arquivo.numero-linha)).

                        NEXT bk-linha-arquivo.
                    END.

                    ASSIGN d-vl-lancamento = fn-conv-deci(TRIM(SUBSTRING(conteudo, 45, 10)), 2) NO-ERROR.

                    IF d-vl-lancamento = 0 THEN
                        NEXT bk-linha-arquivo.

                    ASSIGN v-cdn-unid-negoc        = IF TRIM(SUBSTRING(conteudo, 34, 3)) = "":U      THEN 001  ELSE INTEGER(TRIM(SUBSTRING(conteudo, 34, 3)))
                           v-cod-ccusto            = IF TRIM(SUBSTRING(conteudo, 37, 7)) = "00000":U THEN ""   ELSE TRIM(SUBSTRING(conteudo, 37, 7))
                           v-ind-natur-lancto-ctbl = IF TRIM(SUBSTRING(conteudo, 44, 1)) = "D":U     THEN "DB" ELSE "CR":U
                           v-cod-lote-gko          = STRING(DEC(SUBSTRING(conteudo, 103, 20)),">>>>>>>>>9.9999999999").

                    FIND FIRST tt-transportador
                        WHERE tt-transportador.cod-transportador     = v-cod-transportador
                          AND tt-transportador.cod-estab             = v-cod-estabel
                          AND tt-transportador.cod-cta-ctbl          = TRIM(SUBSTRING(conteudo,  4, 8))
                          AND tt-transportador.cdn-unid-negoc        = v-cdn-unid-negoc
                          AND tt-transportador.cod-ccusto            = v-cod-ccusto
                          AND tt-transportador.ind-natur-lancto-ctbl = v-ind-natur-lancto-ctbl
                          AND tt-transportador.cod-lote-gko          = v-cod-lote-gko
                          AND tt-transportador.nom-completo          = tt-arquivo.nom-completo NO-ERROR.

                    IF NOT AVAILABLE tt-transportador 
                    THEN DO:
                        CREATE tt-transportador.
                        ASSIGN tt-transportador.cod-transportador     = v-cod-transportador
                               tt-transportador.cod-estab             = v-cod-estabel
                               tt-transportador.cod-cta-ctbl          = TRIM(SUBSTRING(conteudo,  4, 8))
                               tt-transportador.cdn-unid-negoc        = v-cdn-unid-negoc
                               tt-transportador.cod-ccusto            = v-cod-ccusto
                               tt-transportador.ind-natur-lancto-ctbl = v-ind-natur-lancto-ctbl
                               tt-transportador.cod-lote-gko          = v-cod-lote-gko
                               tt-transportador.nom-completo          = tt-arquivo.nom-completo
                               tt-transportador.nom-arquivo           = tt-arquivo.nom-arquivo.
                    END.

                    ASSIGN tt-transportador.vl-lancamento = tt-transportador.vl-lancamento + fn-conv-deci(TRIM(SUBSTRING(conteudo, 45, 10)), 2) NO-ERROR.
                END. /* WHEN "075":U THEN DO: */
            END CASE.
        END. /* FOR EACH tt-linha-arquivo */
    END. /* FOR EACH tt-arquivo: */

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Integrando com o EMS 5...":U).

    /* Contabilizaá∆o no EMS 5 */
    RUN esp/gko/gk0004rp-1.p (INPUT  tt-param.dt-ctbl,
                              INPUT  TABLE tt-transportador,
                              INPUT  h-acomp,
                              OUTPUT TABLE tt-log-erros).

    IF VALID-HANDLE(h-acomp) THEN DO:
        RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Msg Monit Integ...":U).
        RUN pi-acompanhar IN h-acomp (INPUT "":U).
    END.

    IF CAN-FIND(FIRST tt-log-erros) THEN DO:
        FOR EACH tt-log-erros:
            CREATE tt-log-gko.
            ASSIGN tt-log-gko.nom-arquivo-integracao = tt-log-erros.nom-completo
                   tt-log-gko.cod-arquivo-integracao = tt-log-erros.nom-arquivo
                   tt-log-gko.log-imp-erro           = YES
                   tt-log-gko.ind-tipo-integracao    = 4
                   tt-log-gko.des-erro-imp           = "Erro integraá∆o EMS 5: Transp/Est/Cta Ctbl/Un Neg/C Custo/Lancto/Lote GKO: ":U + STRING(tt-log-erros.cdn-transportador) + "/":U + tt-log-erros.cod-estab + "/":U + TRIM(tt-log-erros.cod-cta-ctbl) + "/":U + TRIM(STRING(tt-log-erros.cdn-unid-negoc)) + "/":U + TRIM(tt-log-erros.cod-ccusto) + "/":U + TRIM(tt-log-erros.ind-natur-lancto-ctbl) + "/" +  TRIM(tt-log-erros.cod-lote-gko) + " - ":U + TRIM(tt-log-erros.des-msg-erro) + " (":U + STRING(tt-log-erros.num-mensagem) + ")":U + CHR(10) + CHR(10) + TRIM(tt-log-erros.des-msg-ajuda).
        END.

        FOR EACH tt-arquivo:
            IF NOT CAN-FIND(FIRST tt-log-gko
                            WHERE tt-log-gko.cod-arquivo-integracao = tt-arquivo.nom-arquivo) THEN DO:
                CREATE tt-log-gko.
                ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                       tt-log-gko.cod-arquivo-integracao = tt-arquivo.nom-arquivo
                       tt-log-gko.log-imp-erro           = YES
                       tt-log-gko.ind-tipo-integracao    = 4
                       tt-log-gko.des-erro-imp           = "Arquivo n∆o importado por ocorrencia de erro no lote de arquivos.":U.
            END.
        END.
    END.
    ELSE DO:
        FOR EACH tt-arquivo:
            CREATE tt-log-gko.
            ASSIGN tt-log-gko.nom-arquivo-integracao = tt-arquivo.nom-completo
                   tt-log-gko.cod-arquivo-integracao = tt-arquivo.nom-arquivo
                   tt-log-gko.log-imp-erro           = NO
                   tt-log-gko.ind-tipo-integracao    = 4
                   tt-log-gko.des-erro-imp           = "":U.

            OS-COPY   VALUE(tt-log-gko.nom-arquivo-integracao) VALUE(v-dir-destino + tt-log-gko.cod-arquivo-integracao).
            OS-DELETE VALUE(tt-log-gko.nom-arquivo-integracao) NO-ERROR.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-carrega-linha-arq :
/*------------------------------------------------------------------------------
  Purpose:     Buscar arquivo(s) para importaá∆o da(s) fatura(s) GKO.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-dir-origem     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-conteudo-linha AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-numero-linha   AS INTEGER     NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Carregando linhas arquivo...":U).

    EMPTY TEMP-TABLE tt-arquivo.
    EMPTY TEMP-TABLE tt-linha-arquivo.

    /* Identificar o diret¢rio origem do(s) arquivo(s) */
    IF NOT CAN-FIND(FIRST ponto-programa NO-LOCK
                    WHERE ponto-programa.nome-programa = "gk0004":U
                      AND ponto-programa.ponto         = 1) THEN DO:
        CREATE tt-log-gko.
        ASSIGN tt-log-gko.nom-arquivo-integracao = "--":U
               tt-log-gko.log-imp-erro           = YES
               tt-log-gko.ind-tipo-integracao    = 4
               tt-log-gko.des-erro-imp           = "ParÉmetros dos diret¢rios n∆o encontrado!":U + CHR(10) + "Nome Programa: GK0004 - Ponto: 1":U.

        RETURN "NOK":U.
    END.

    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "gk0004":U
          AND ponto-programa.ponto         = 1,
        EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

        IF conteudo-programa.conteudo                    <> "":U AND
           NUM-ENTRIES(conteudo-programa.conteudo, ";":U) > 1    THEN DO:

            /* Diret¢rio no sistema operacional WIN32 */
            IF OPSYS = "WIN32":U THEN DO:
                IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "SAIDAGKOWIN32":U THEN
                    ASSIGN c-dir-origem = ENTRY(2, conteudo-programa.conteudo, ";":U).
                IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "BACKUPGKOWIN32":U THEN
                    ASSIGN v-dir-destino = ENTRY(2, conteudo-programa.conteudo, ";":U).
            END.
            /* Diret¢rio no sistema operacional UNIX */
            ELSE DO:
                IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "SAIDAGKOUNIX":U THEN
                    ASSIGN c-dir-origem = ENTRY(2, conteudo-programa.conteudo, ";":U).
                IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "BACKUPGKOUNIX":U THEN
                    ASSIGN v-dir-destino = ENTRY(2, conteudo-programa.conteudo, ";":U).
            END.
        END.
    END.

    ASSIGN c-dir-origem  = REPLACE(c-dir-origem,  "~\":U, "/":U)
           v-dir-destino = REPLACE(v-dir-destino, "~\":U, "/":U).

    IF SUBSTRING(v-dir-destino, LENGTH(v-dir-destino), 1) <> "/":U THEN
        ASSIGN v-dir-destino = v-dir-destino + "/":U.

    FILE-INFO:FILE-NAME = c-dir-origem.

    IF FILE-INFO:FULL-PATHNAME           = ?    OR
       FILE-INFO:FULL-PATHNAME           = "":U OR
       INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN DO:
        CREATE tt-log-gko.
        ASSIGN tt-log-gko.nom-arquivo-integracao = "--":U
               tt-log-gko.log-imp-erro           = YES
               tt-log-gko.ind-tipo-integracao    = 4
               tt-log-gko.des-erro-imp           = "Diret¢rio de origem n∆o encontrado!":U.

        RETURN "NOK":U.
    END.

    FILE-INFO:FILE-NAME = v-dir-destino.

    IF FILE-INFO:FULL-PATHNAME           = ?    OR
       FILE-INFO:FULL-PATHNAME           = "":U OR
       INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0    THEN DO:
        CREATE tt-log-gko.
        ASSIGN tt-log-gko.nom-arquivo-integracao = "--":U
               tt-log-gko.log-imp-erro           = YES
               tt-log-gko.ind-tipo-integracao    = 4
               tt-log-gko.des-erro-imp           = "Diret¢rio de destino n∆o encontrado!":U.

        RETURN "NOK":U.
    END.

    INPUT STREAM str-in FROM OS-DIR(c-dir-origem) NO-ECHO.
    REPEAT:
        CREATE tt-arquivo.
        IMPORT STREAM str-in tt-arquivo.nom-arquivo
                             tt-arquivo.nom-completo
                             tt-arquivo.ind-tipo-arquivo.
    END.
    INPUT STREAM str-in CLOSE.

    FOR EACH tt-arquivo:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Arquivo: ":U + TRIM(tt-arquivo.nom-arquivo)).

        IF NOT tt-arquivo.nom-arquivo BEGINS "frpfap":U OR
           tt-arquivo.ind-tipo-arquivo    <> "F":U      THEN
            DELETE tt-arquivo.
    END.

    IF NOT CAN-FIND(FIRST tt-arquivo) THEN DO:
        CREATE tt-log-gko.
        ASSIGN tt-log-gko.nom-arquivo-integracao = "--":U
               tt-log-gko.log-imp-erro           = YES
               tt-log-gko.ind-tipo-integracao    = 4
               tt-log-gko.des-erro-imp           = "Nenhum arquivo encontrado!":U.

        RETURN "NOK":U.
    END.

    FOR EACH tt-arquivo:
        ASSIGN i-numero-linha = 0.

        INPUT STREAM str-in FROM VALUE(SEARCH(tt-arquivo.nom-completo)).
        REPEAT:
            IMPORT STREAM str-in UNFORMATTED c-conteudo-linha.

            ASSIGN i-numero-linha = i-numero-linha + 1.

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Arquivo: ":U + TRIM(tt-arquivo.nom-arquivo) + " - Linha: ":U + TRIM(STRING(i-numero-linha))).

            IF c-conteudo-linha <> "":U THEN DO:
                CREATE tt-linha-arquivo.
                ASSIGN tt-linha-arquivo.nome-arquivo   = tt-arquivo.nom-completo
                       tt-linha-arquivo.numero-linha   = i-numero-linha
                       tt-linha-arquivo.conteudo-linha = c-conteudo-linha.
            END.
        END.
        INPUT STREAM str-in CLOSE.
    END.

    IF NOT CAN-FIND(FIRST tt-linha-arquivo) THEN DO:
        CREATE tt-log-gko.
        ASSIGN tt-log-gko.nom-arquivo-integracao = "--":U
               tt-log-gko.log-imp-erro           = YES
               tt-log-gko.ind-tipo-integracao    = 4
               tt-log-gko.des-erro-imp           = "Arquivo encontrado est† em branco!":U.

        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.


/* ************************  Function Implementations ***************** */

FUNCTION fn-conv-deci RETURNS DECIMAL
  ( p-num AS CHARACTER, p-decimals AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-aux AS DECIMAL     NO-UNDO.

    ASSIGN p-num  = TRIM(REPLACE(REPLACE(p-num, ".":U, "#":U), ",":U, "#":U))
           de-aux = DECIMAL(TRIM(p-num)) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    ASSIGN de-aux = 0
           de-aux = de-aux + DECIMAL(SUBSTRING(p-num, 1, LENGTH(p-num) - p-decimals))
           de-aux = de-aux + (DECIMAL(SUBSTRING(p-num, (LENGTH(p-num) - p-decimals) + 1, 2)) / EXP(10, p-decimals)).

    RETURN de-aux.

END FUNCTION.

FUNCTION fn-conv-data RETURNS DATE
  ( p-date AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-day   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-month AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-year  AS INTEGER     NO-UNDO.

    ASSIGN p-date = TRIM(p-date).

    IF NUM-ENTRIES(p-date, "/":U) < 3 THEN
        RETURN ?.

    ASSIGN i-day = INTEGER(TRIM(ENTRY(1, p-date, "/":U))) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    ASSIGN i-month = INTEGER(TRIM(ENTRY(2, p-date, "/":U))) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    ASSIGN i-year = INTEGER(TRIM(ENTRY(3, p-date, "/":U))) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    RETURN DATE(i-month, i-day, i-year).

END FUNCTION.

FUNCTION fn-conv-logi RETURNS LOGICAL
  ( p-logical AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    ASSIGN p-logical = TRIM(p-logical).

    CASE p-logical:
        WHEN "s":U    OR
        WHEN "sim":U  OR
        WHEN "y":U    OR
        WHEN "yes"    OR
        WHEN "t":U    OR
        WHEN "true":U THEN
            RETURN YES.
        WHEN "n":U     OR
        WHEN "nao":U   OR
        WHEN "n∆o":U   OR
        WHEN "no"      OR
        WHEN "f":U     OR
        WHEN "false":U THEN
            RETURN NO.
        OTHERWISE
            RETURN ?.
    END CASE.

END FUNCTION.

FUNCTION fn-conv-inte RETURNS INTEGER
  ( p-num AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.

    ASSIGN i-aux = INTEGER(TRIM(p-num)) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ?.

    RETURN i-aux.

END FUNCTION.


