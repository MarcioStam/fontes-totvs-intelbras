
DEFINE NEW GLOBAL SHARED VARIABLE r-ord-prod-cp0301-upc AS ROWID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ok-orig-cp0302c-upc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-save-orig-cp0302c-upc  AS WIDGET-HANDLE NO-UNDO.

DEFINE BUFFER b-ord FOR ord-prod.

{esp/es0018.i}


EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "bloq-rep", /* Nome do programa */
                   INPUT 1,          /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).    

FOR FIRST b-ord NO-LOCK
    WHERE ROWID(b-ord) = r-ord-prod-cp0301-upc:

    IF CAN-FIND(FIRST tt-prog-ponto NO-LOCK 
                WHERE entry(1, tt-prog-ponto.conteudo, ";") = b-ord.cod-estabel
                AND   ENTRY(2, tt-prog-ponto.conteudo, ";") = "bloqueia") THEN DO:

        IF b-ord.tipo = 1 THEN DO:

            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Emiss∆o de Ordens Internas est† bloqueada para realizaá∆o do Planejamento. Aguarde liberaá∆o.").

            RETURN NO-APPLY.

        END.

    END.

END.


APPLY 'CHOOSE':U TO wh-bt-ok-orig-cp0302c-upc.
