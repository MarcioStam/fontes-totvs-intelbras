/******* INCLUDE UTILIZADA NOS PROGRAMA ESFTP004, ESFTP010, ESFTP011 *****/

assign l-volta = no.

FIND FIRST tt-prog-ponto-tmp
     WHERE tt-prog-ponto-tmp.conteudo = ped-venda.nat-operacao 
     AND   tt-prog-ponto-tmp.ponto = 1 NO-ERROR.

IF natur-oper.log-oper-triang = YES THEN DO:
   IF CAN-FIND(FIRST tt-prog-ponto-tmp                                     WHERE
                     tt-prog-ponto-tmp.conteudo = ped-venda.nat-operacao AND
                     tt-prog-ponto-tmp.ponto = 1)                          THEN DO:
      ASSIGN l-volta = YES.
   END.

END.
IF l-volta = YES THEN 
    NEXT.


IF natur-oper.baixa-estoq = YES THEN DO:
   FIND FIRST tt-prog-ponto-tmp no-lock
       WHERE tt-prog-ponto-tmp.ponto = 2
       AND   tt-prog-ponto-tmp.conteudo = ped-venda.nat-operacao NO-ERROR.

   IF AVAIL tt-prog-ponto-tmp THEN
      ASSIGN l-volta = YES.
END.
ELSE DO:
    FIND FIRST tt-prog-ponto-tmp no-lock
        WHERE tt-prog-ponto-tmp.ponto = 3
        AND   tt-prog-ponto-tmp.conteudo = ped-venda.nat-operacao NO-ERROR.

    IF NOT AVAIL tt-prog-ponto-tmp THEN
       ASSIGN l-volta = YES.

END.
IF l-volta = YES THEN
    NEXT.




