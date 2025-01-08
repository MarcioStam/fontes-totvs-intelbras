EMPTY TEMP-TABLE tt-prog-ponto.
    
RUN esp/es0018p.p (INPUT "ALM-WMS":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

IF CAN-FIND(FIRST tt-prog-ponto
            WHERE tt-prog-ponto.conteudo = v_cod_estab_usuar) THEN DO:
   MESSAGE "Programa desabilitado ao usu rio corrente."
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   APPLY "close" TO THIS-PROCEDURE.
END.
