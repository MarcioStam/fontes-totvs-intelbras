def new global shared var whdes-pct-desconto-inform   as widget-handle no-undo.
def new global shared var wh-nome-abrev-pd4000        as widget-handle no-undo.
def new global shared var wh-nr-pedcli-pd4000         as widget-handle no-undo.
def new global shared var whit-codigo                 AS widget-handle no-undo.
def new global shared var whnr-sequencia-pd4000       as widget-handle no-undo.  
def new global shared var whqt-pedida                 as widget-handle no-undo.
def new global shared var wh-nat-operacao-item-pd4000 as widget-handle no-undo.
def new global shared var whvl-preuni                  as widget-handle no-undo.

IF  NOT VALID-HANDLE(whdes-pct-desconto-inform) THEN 
    RETURN "OK".

FIND ped-item
    WHERE ped-item.nome-abrev   = wh-nome-abrev-pd4000:SCREEN-VALUE
      AND ped-item.nr-pedcli    = wh-nr-pedcli-pd4000:SCREEN-VALUE
      AND ped-item.it-codigo    = whit-codigo:SCREEN-VALUE
      AND ped-item.nr-sequencia = int(whnr-sequencia-pd4000:SCREEN-VALUE) NO-LOCK no-error.

IF  NOT AVAIL ped-item THEN
    RETURN "OK".


DEFINE VARIABLE de-liquido LIKE ped-item.vl-preori NO-UNDO.
DEFINE VARIABLE de-preco   AS DECIMAL DECIMALS 5 NO-UNDO.

FOR FIRST ped-venda NO-LOCK
    WHERE ped-venda.nome-abrev = wh-nome-abrev-pd4000:SCREEN-VALUE
      AND ped-venda.nr-pedcli  = wh-nr-pedcli-pd4000:SCREEN-VALUE:


    /* Retorna o preáo de tabela acrescendo os impotos */
    RUN esp/pdp/espdp071.p (INPUT ped-venda.cod-estabel,
                            INPUT wh-nome-abrev-pd4000:SCREEN-VALUE,
                            INPUT wh-nr-pedcli-pd4000:SCREEN-VALUE,
                            INPUT whnr-sequencia-pd4000:SCREEN-VALUE,
                            INPUT whit-codigo:SCREEN-VALUE,
                            INPUT DEC(whqt-pedida:SCREEN-VALUE),
                            INPUT wh-nat-operacao-item-pd4000:SCREEN-VALUE,
                            OUTPUT de-preco).

    ASSIGN de-liquido = dec(whvl-preuni:screen-value).

    RUN esp/pdp/espdp074.p (INPUT ped-venda.nome-abrev,
                            INPUT ped-venda.nr-pedcli,   
                            INPUT whnr-sequencia-pd4000:SCREEN-VALUE,
                            INPUT whit-codigo:SCREEN-VALUE,   
                            INPUT "",   
                            INPUT YES,
                            TRIM(whdes-pct-desconto-inform:SCREEN-VALUE),
                            INPUT-OUTPUT de-liquido). /* preori sem os descontos - l°quido */

    IF  de-preco = 0  THEN
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT "Preáo m°nimo para o item n∆o existe na tabela de preáos.").
    ELSE
        IF  de-liquido < de-preco THEN  
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT "Preáo Informado Ç Inferior ao preáo m°nimo." +
                                                                  "~~" +
                                                                  "Preáo Informado (aplicando descontos): " + trim(STRING(de-liquido,">>>>>>>9.99999")) + " - ê Inferior ao preáo m°nimo + impostos: " + 
                                                                  "(" + trim(STRING(de-preco, ">>>>>>>9.99999")) + ")"
                                                                  ).
END.
