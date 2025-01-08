/* indicador-mp - rpc

  Programa para carga e totaliza‡Æo das informa‡äes do indicador de MP
  
  Fl vio Schoenell - 06/03/06

*/

/* Defini‡Æo da temp-table "tt-prog-ponto" */
{esp/es0018.i}

DEFINE TEMP-TABLE tt-conta NO-UNDO
    FIELD cod_cta_ctbl AS CHARACTER
    FIELD mes          AS INTEGER
    FIELD ano          AS INTEGER
    FIELD valor-orcado AS DECIMAL
    FIELD valor-real   AS DECIMAL
    INDEX cod_cta_ctbl IS PRIMARY
        cod_cta_ctbl.

DEFINE TEMP-TABLE tt-conta-tot NO-UNDO
    FIELD cod_cta_ctbl AS CHARACTER
    FIELD valor-orcado AS DECIMAL   FORMAT "->>>,>>>,>>9.999999":U EXTENT 12
    FIELD valor-real   AS DECIMAL   FORMAT "->>>,>>>,>>9.999999":U EXTENT 12
    INDEX cod_cta_ctbl IS PRIMARY
        cod_cta_ctbl.

DEFINE TEMP-TABLE tt-estoque NO-UNDO
    FIELD cod_cta_ctbl AS CHARACTER
    FIELD dia          AS INTEGER   FORMAT "99":U
    FIELD mes          AS INTEGER
    FIELD ano          AS INTEGER
    FIELD valor        AS DECIMAL   FORMAT "->>>,>>>,>>9.999999":U
    INDEX cod_cta_ctbl IS PRIMARY
        cod_cta_ctbl.

DEFINE TEMP-TABLE tt-estoque-tot NO-UNDO
    FIELD cod_cta_ctbl AS CHARACTER
    FIELD dia          AS INTEGER   FORMAT "99":U
    FIELD valor        AS DECIMAL   FORMAT "->>>,>>>,>>9.999999":U EXTENT 12
    INDEX cod_cta_ctbl IS PRIMARY
        cod_cta_ctbl.

DEFINE TEMP-TABLE tt-periodo NO-UNDO
    FIELD mes AS CHARACTER
    FIELD ano AS CHARACTER.

DEFINE VARIABLE i-cont    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-dia     AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-linha   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cb-ano    AS CHARACTER   NO-UNDO EXTENT 12.
DEFINE VARIABLE cb-mes    AS CHARACTER   NO-UNDO EXTENT 12.
DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir     AS CHARACTER   NO-UNDO.

DEFINE INPUT  PARAMETER cc_codigo AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-periodo.
DEFINE OUTPUT PARAMETER TABLE FOR tt-conta.
DEFINE OUTPUT PARAMETER TABLE FOR tt-conta-tot.
DEFINE OUTPUT PARAMETER TABLE FOR tt-estoque.
DEFINE OUTPUT PARAMETER TABLE FOR tt-estoque-tot.


EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX":U THEN DO:
    RUN esp/es0018p.p (INPUT  "ES0940":U,
                       INPUT  2,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
        ASSIGN c-dir = c-dir + "/":U.
END.
ELSE DO:
    RUN esp/es0018p.p (INPUT  "ES0940":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
    END.

    IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
        ASSIGN c-dir = c-dir + "~\":U.
END.

FIND FIRST tt-periodo NO-ERROR.

DO i-cont = 1 TO 12:
    ASSIGN cb-mes[i-cont] = tt-periodo.mes
           cb-ano[i-cont] = tt-periodo.ano.

    FIND NEXT tt-periodo NO-ERROR.

    IF NOT AVAILABLE tt-periodo THEN
        LEAVE.
END.

RUN pi-carga.
RUN pi-totaliza.
RUN pi-carga-estoque.
RUN pi-totaliza-estoque.

RETURN "OK":U.


PROCEDURE pi-carga:
    EMPTY TEMP-TABLE tt-conta.

    DO i-cont = 1 TO 12:
        IF cb-mes[i-cont] <> "":U AND
           cb-ano[i-cont] <> "":U THEN DO:
            IF cc_codigo = "empresa":U THEN DO:
                IF OPSYS = "UNIX":U THEN
                    ASSIGN c-arquivo = ?.
                ELSE
                    ASSIGN c-arquivo = SEARCH(c-dir + "emp":U + cb-ano[i-cont] + STRING(cb-mes[i-cont], "99":U)).
            END.

            IF cc_codigo BEGINS "CC:":U THEN DO:
                IF OPSYS = "UNIX":U THEN
                    ASSIGN c-arquivo = ?.
                ELSE
                    ASSIGN c-arquivo = SEARCH(c-dir + "orc":U + cb-ano[i-cont] + STRING(cb-mes[i-cont], "99":U) + SUBSTRING(ENTRY(2, cc_codigo, ":":U), 4, 5)).
            END.

            IF cc_codigo BEGINS "UNI:":U THEN DO:
                IF OPSYS = "UNIX":U THEN
                    ASSIGN c-arquivo = ?.
                ELSE
                    ASSIGN c-arquivo = SEARCH(c-dir + "uni" + cb-ano[i-cont] + STRING(cb-mes[i-cont], "99":U) + ENTRY(2, cc_codigo, ":":U)).
            END.

            IF cc_codigo BEGINS "DIV:":U THEN DO:
                IF OPSYS = "UNIX":U THEN
                    ASSIGN c-arquivo = ?.
                ELSE
                    ASSIGN c-arquivo = SEARCH(c-dir + "div":U + cb-ano[i-cont] + STRING(cb-mes[i-cont], "99":U) + ENTRY(2, cc_codigo, ":":U)).
            END.

            IF c-arquivo <> ? THEN DO:
                INPUT FROM VALUE(c-arquivo).
                REPEAT:
                    IMPORT UNFORMATTED c-linha.

                    ASSIGN c-linha = REPLACE(c-linha, "~"":U, "":U).

                    CREATE tt-conta.
                    ASSIGN tt-conta.cod_cta_ctbl = ENTRY(1, c-linha, ";":U)
                           tt-conta.valor-orcado = DECIMAL(ENTRY(2, c-linha, ";":U))
                           tt-conta.valor-real   = DECIMAL(ENTRY(3, c-linha, ";":U))
                           tt-conta.mes          = INTEGER(cb-mes[i-cont])
                           tt-conta.ano          = INTEGER(cb-ano[i-cont]).
                END.
                INPUT CLOSE.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-carga-estoque:
    EMPTY TEMP-TABLE tt-estoque.

    DO i-cont = 1 TO 12:
        IF cb-mes[i-cont] <> "":U AND
           cb-ano[i-cont] <> "":U THEN DO:
            IF OPSYS = "UNIX":U THEN
                ASSIGN c-arquivo = ?.
            ELSE
                ASSIGN c-arquivo = SEARCH(c-dir + "est" + cb-ano[i-cont] + STRING(cb-mes[i-cont], "99":U) + cc_codigo).

            IF c-arquivo <> ? THEN DO:
                INPUT FROM VALUE(c-arquivo).
                REPEAT:
                    IMPORT UNFORMATTED c-linha.

                    ASSIGN c-linha = REPLACE(c-linha, "~"":U, "":U).

                    CREATE tt-estoque.
                    ASSIGN tt-estoque.cod_cta_ctbl = ENTRY(1, c-linha, ";":U)
                           tt-estoque.valor        = DECIMAL(ENTRY(3, c-linha, ";":U))
                           tt-estoque.dia          = INTEGER(ENTRY(1, ENTRY(2, c-linha, ";":U), "/":U))
                           tt-estoque.mes          = INTEGER(cb-mes[i-cont])
                           tt-estoque.ano          = INTEGER(cb-ano[i-cont]).
                END.
                INPUT CLOSE.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-totaliza:
    EMPTY TEMP-TABLE tt-conta-tot.

    DO i-cont = 1 TO 12:
        FOR EACH tt-conta
            WHERE tt-conta.mes = INTEGER(cb-mes[i-cont])
              AND tt-conta.ano = INTEGER(cb-ano[i-cont]):
            FIND tt-conta-tot
                WHERE tt-conta-tot.cod_cta_ctbl = tt-conta.cod_cta_ctbl NO-ERROR.

            IF NOT AVAILABLE tt-conta-tot THEN DO:
                CREATE tt-conta-tot.
                ASSIGN tt-conta-tot.cod_cta_ctbl = tt-conta.cod_cta_ctbl.
            END.

            ASSIGN tt-conta-tot.valor-orcado[i-cont] = tt-conta-tot.valor-orcado[i-cont] + tt-conta.valor-orcado
                   tt-conta-tot.valor-real[i-cont]   = tt-conta-tot.valor-real[i-cont]   + tt-conta.valor-real.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-totaliza-estoque:
    EMPTY TEMP-TABLE tt-estoque-tot.

    DO i-cont = 1 TO 12:
        DO i-dia = 1 TO 31:
            FOR EACH tt-estoque
                WHERE tt-estoque.mes = INTEGER(cb-mes[i-cont])
                  AND tt-estoque.ano = INTEGER(cb-ano[i-cont])
                  AND tt-estoque.dia = i-dia:
                FIND tt-estoque-tot
                    WHERE tt-estoque-tot.cod_cta_ctbl = tt-estoque.cod_cta_ctbl
                      AND tt-estoque-tot.dia          = i-dia NO-ERROR.

                IF NOT AVAILABLE tt-estoque-tot THEN DO:
                    CREATE tt-estoque-tot.
                    ASSIGN tt-estoque-tot.cod_cta_ctbl = tt-estoque.cod_cta_ctbl
                           tt-estoque-tot.dia          = i-dia.
                END.

                ASSIGN tt-estoque-tot.valor[i-cont] = tt-estoque-tot.valor[i-cont] + tt-estoque.valor.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

