FUNCTION fnExibePrecos RETURNS LOG (INPUT p-matricula AS CHAR) :
    DEFINE VARIABLE l-exibe-preco AS LOGICAL     NO-UNDO.

    RUN esp/es0018p.p (INPUT "ESCEP055":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST usuar-mater NO-LOCK
         WHERE usuar-mater.cod-usuario = p-matricula NO-ERROR.
    
     /*S¢ mostra valores para os compradores*/
    IF (AVAIL usuar-mater
          AND usuar-mater.usuar-comprador)
           OR CAN-FIND (FIRST tt-prog-ponto              
                        WHERE tt-prog-ponto.conteudo = p-matricula) THEN 
        ASSIGN l-exibe-preco = YES.
    ELSE                             
        ASSIGN l-exibe-preco = NO.

    RETURN l-exibe-preco.

END FUNCTION.
