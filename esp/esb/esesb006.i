/*
{1} C¢digo da Mensagem
{2} C¢digo da Trigger
{3} Nome da Tabela
*/


DEF VAR c-dir-spool AS CHAR NO-UNDO.
DEF VAR i           AS INT  NO-UNDO.

{esp/esb/esesb000.i}
{esp/es0018.i}

RUN esp/es0018p.p (INPUT "spool-canais", /* Nome do programa */
                   INPUT 1,              /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAIL tt-prog-ponto THEN DO:
    ASSIGN c-dir-spool = tt-prog-ponto.conteudo + "/log_erros_canais.csv".
    OUTPUT TO VALUE (c-dir-spool) APPEND.
END.

run esp/esb/esesb003.p (INPUT {1},
                        INPUT raw-param,
                        OUTPUT TABLE resultado).

FIND FIRST resultado NO-ERROR.
IF NOT AVAIL resultado THEN DO:
    PUT UNFORMATTED {1} + ";" + {2} + ";" + {3} + ";" + "NÆo houve retorno do barramento!" SKIP .
END.
ELSE IF NOT resultado.sucesso THEN DO:
    DO i = 1 TO NUM-ENTRIES(resultado.mensagem,";"):
        PUT UNFORMATTED {1} + ";" + {2} + ";" + {3} + ";" + ENTRY(i,resultado.mensagem,";") SKIP.
        ASSIGN i = i + 1.
    END.

END.

OUTPUT CLOSE.
