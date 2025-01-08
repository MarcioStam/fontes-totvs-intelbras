/******* INCLUDE UTILIZADA NOS PROGRAMA ESFTP004, ESFTP010, ESFTP011 *****/

assign l-volta = no.

FIND FIRST tt-prog-ponto-tmp
     WHERE tt-prog-ponto-tmp.conteudo = nota-fiscal.nat-operacao 
     AND   tt-prog-ponto-tmp.ponto = 1 NO-ERROR.

IF natur-oper.log-oper-triang = YES THEN DO:
   IF CAN-FIND(FIRST tt-prog-ponto-tmp                                     WHERE
                     tt-prog-ponto-tmp.conteudo = nota-fiscal.nat-operacao AND
                     tt-prog-ponto-tmp.ponto = 1)                          THEN DO:
      ASSIGN l-volta = YES.
   END.

END.
IF l-volta = YES THEN 
    NEXT.


IF natur-oper.baixa-estoq = YES THEN DO:
   FIND FIRST tt-prog-ponto-tmp no-lock
       WHERE tt-prog-ponto-tmp.ponto = 2
       AND   tt-prog-ponto-tmp.conteudo = nota-fiscal.nat-operacao NO-ERROR.

   IF AVAIL tt-prog-ponto-tmp THEN
      ASSIGN l-volta = YES.
END.
ELSE DO:
    FIND FIRST tt-prog-ponto-tmp no-lock
        WHERE tt-prog-ponto-tmp.ponto = 3
        AND   tt-prog-ponto-tmp.conteudo = nota-fiscal.nat-operacao NO-ERROR.

    IF NOT AVAIL tt-prog-ponto-tmp THEN
       ASSIGN l-volta = YES.

END.
IF l-volta = YES THEN
    NEXT.




/*

                                                   
    IF   natur-oper.log-oper-triang = YES       AND
         nota-fiscal.nat-operacao   <> "694911" AND
         nota-fiscal.nat-operacao   <> "694952" AND
         nota-fiscal.nat-operacao   <> "594908"  THEN 
         NEXT.

    IF   natur-oper.baixa-estoq AND 
        (nota-fiscal.nat-operacao = "594912" OR
         nota-fiscal.nat-operacao = "594927" OR
         nota-fiscal.nat-operacao = "594939" OR
         nota-fiscal.nat-operacao = "594940" OR
         nota-fiscal.nat-operacao = "694941" OR
         nota-fiscal.nat-operacao = "694943" OR
         nota-fiscal.nat-operacao = "694930") THEN 
        NEXT.
    ELSE
        IF natur-oper.baixa-estoq = NO           AND 
           (nota-fiscal.nat-operacao <> "694911"  AND
            nota-fiscal.nat-operacao <> "694952"  AND
            nota-fiscal.nat-operacao <> "694939"  AND
            nota-fiscal.nat-operacao <> "594939"  AND
            nota-fiscal.nat-operacao <> "594908"  and
            nota-fiscal.nat-operacao <> "694940") THEN 
        NEXT.
  
*/
