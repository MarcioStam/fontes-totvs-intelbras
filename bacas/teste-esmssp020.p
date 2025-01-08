{esp/mssp/esmssp020.i}

RUN esp/mssp/esmssp020.p (INPUT "1990087",
                          OUTPUT TABLE tt-item,
                          OUTPUT TABLE tt-item-fabric,
                          OUTPUT TABLE tt-mensagem).

FOR EACH tt-item:

    DISP tt-item.cest.
END.
