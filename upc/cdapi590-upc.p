
/**  Programa..: cdapi590-upc.p                                            **
 **  Autor.....: Anderson Hoepers                                          **
 **  Data......: 01/02/2017 - Desenvolvimento                              **
 **  Descricao.: Alterar pasta destino do XML quando sistema operacional   **
 **              for diferente de windows                                  **
 **  Versão....: 001 - 01/02/2017                                          **
 ***************************************************************************/

{include/i-prgvrs.i cdapi590-upc 12.00.01.011 } 
{esp/es0018.i}
{include/i-epc200.i1}

DEF INPUT        PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VAR l-program-especifico AS LOG INIT NO NO-UNDO.
DEFINE VAR i                    AS INT         NO-UNDO.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT  "cdapi590":U,
                   INPUT  3,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR EACH tt-prog-ponto:
    DO i = 1 TO 20:
        IF PROGRAM-NAME(i) MATCHES '*' + tt-prog-ponto.conteudo + '*'  THEN
            ASSIGN l-program-especifico = YES.
    END.
END.

IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(01): " + PROGRAM-NAME(01)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(02): " + PROGRAM-NAME(02)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(03): " + PROGRAM-NAME(03)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(04): " + PROGRAM-NAME(04)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(05): " + PROGRAM-NAME(05)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(06): " + PROGRAM-NAME(06)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(07): " + PROGRAM-NAME(07)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(08): " + PROGRAM-NAME(08)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(09): " + PROGRAM-NAME(09)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(10): " + PROGRAM-NAME(10)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(11): " + PROGRAM-NAME(11)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(12): " + PROGRAM-NAME(12)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(13): " + PROGRAM-NAME(13)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(14): " + PROGRAM-NAME(14)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(15): " + PROGRAM-NAME(15)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(16): " + PROGRAM-NAME(16)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(17): " + PROGRAM-NAME(17)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(18): " + PROGRAM-NAME(18)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(19): " + PROGRAM-NAME(19)).
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("PROGRAM-NAME(20): " + PROGRAM-NAME(20)).
IF OPSYS = "UNIX" THEN log-manager:write-message("cdapi590-upc -> l-program-especifico : " + STRING( l-program-especifico)).

CASE p-ind-event:
    WHEN ("AtualizaDirOUTTC2") THEN DO:

        EMPTY TEMP-TABLE tt-prog-ponto.

        IF  OPSYS = "WIN32" THEN DO:
        
            RUN esp/es0018p.p (INPUT "cdapi590", /* Nome do programa */
                               INPUT 2,          /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto). 
        END.
        ELSE
            RUN esp/es0018p.p (INPUT "cdapi590",  /* Nome do programa */
                               INPUT 1,           /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto). 

        FIND FIRST tt-prog-ponto.
        
        IF AVAIL tt-prog-ponto THEN DO:
            FOR FIRST tt-epc
               WHERE  tt-epc.cod-event     = "AtualizaDirOUTTC2"
                 AND  tt-epc.cod-parameter = "c-dir-dest":
                 ASSIGN tt-epc.val-parameter = (IF  l-program-especifico THEN tt-prog-ponto.conteudo + "/TMP" ELSE tt-prog-ponto.conteudo).

                 IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("tt-epc.val-parameter: " + tt-epc.val-parameter).
                 IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("tt-prog-ponto.conteudo: " + tt-prog-ponto.conteudo).
            END.
        END.
    END.
END.



