/******* INCLUDE UTILIZADA NO PROGRAMA ESFTP004 *****/

FOR EACH tt-prog-ponto-tmp                            WHERE
         tt-prog-ponto-tmp.nome-programa = "esftp004" AND
         tt-prog-ponto-tmp.ponto = 4:                  
    IF CAN-FIND(FIRST cli-difer WHERE
                      cli-difer.cod-emitente = nota-fiscal.cod-emitente    AND
                      cli-difer.cc-codigo    = tt-prog-ponto-tmp.conteudo) THEN DO: 
       ASSIGN Achou-Cli-Dif = YES.
       NEXT.
    END.
END.
