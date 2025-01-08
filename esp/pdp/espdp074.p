/*******************************************************************************/
/* Programa espdp071 - Retornar o pre‡o l¡quido - j  aplicando os descontos    */
/* Data 05/11/2012                                                             */
/* Autor: Roger Marcelino Bruhn                                                */
/*******************************************************************************/

DEF INPUT PARAM p-nome-abrev                   LIKE ped-venda.nome-abrev   NO-UNDO.
DEF INPUT PARAM p-nr-pedcli                    LIKE ped-venda.nr-pedcli    NO-UNDO.
DEF INPUT PARAM p-nr-sequencia                 LIKE ped-item.nr-sequencia  NO-UNDO.
DEF INPUT PARAM p-it-codigo                    LIKE ped-item.it-codigo     NO-UNDO.
DEF INPUT PARAM p-cod-refer                    LIKE ped-item.cod-refer     NO-UNDO.
DEF INPUT PARAM l-upc-pd4000                   AS LOGICAL NO-UNDO.
DEF INPUT PARAM pdes-pct-desconto-inform-item  LIKE ped-item.des-pct-desconto-inform NO-UNDO.
DEF INPUT-OUTPUT PARAM de-liquido              LIKE ped-item.vl-preori NO-UNDO.

DEF VAR de-desconto AS DEC EXTENT 20.

FOR FIRST ped-venda NO-LOCK
    WHERE ped-venda.nome-abrev = p-nome-abrev
      AND ped-venda.nr-pedcli  = p-nr-pedcli:
END.

FOR FIRST ped-item
    WHERE ped-item.nome-abrev   = p-nome-abrev
      AND ped-item.nr-pedcli    = p-nr-pedcli
      AND ped-item.nr-sequencia = p-nr-sequencia
      AND ped-item.it-codigo    = p-it-codigo
      AND ped-item.cod-refer    = p-cod-refer NO-LOCK:
END.

RUN pi-aplica-descontos.

RETURN "OK".

/* Aplica Descontos */
PROCEDURE pi-aplica-descontos:
    DEF VAR i-aux AS INTEGER NO-UNDO.

    DEFINE VARIABLE b AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE e AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE g AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE h AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE j AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE m AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE n AS DECIMAL     NO-UNDO.
    
    /*Verifica desconto informado no PEDIDO*/
    IF  trim(ped-venda.des-pct-desconto-inform) <> "" THEN DO:
        RUN pi-extrai-descontos (ped-venda.des-pct-desconto-inform).
        DO  i-aux = 1 TO 20:   
            IF de-desconto[i-aux] = 0 THEN LEAVE.
            de-liquido = de-liquido - ((de-liquido * de-desconto[i-aux]) / 100).
        END.
    END.

    /*Verifica desconto informado no ITEM DO PEDIDO*/
    IF  NOT l-upc-pd4000
    AND AVAIL ped-item AND trim(ped-item.des-pct-desconto-inform) <> "" THEN
        ASSIGN  pdes-pct-desconto-inform-item = trim(ped-item.des-pct-desconto-inform).
    
    IF  pdes-pct-desconto-inform-item <> "" THEN DO:
       RUN pi-extrai-descontos (INPUT pdes-pct-desconto-inform-item).
        DO  i-aux = 1 TO 20:   
            IF de-desconto[i-aux] = 0 THEN LEAVE.
            de-liquido = de-liquido - ((de-liquido * de-desconto[i-aux]) / 100).
        END.
    END.

    ASSIGN c = ped-venda.val-pct-desconto-tab-preco
           d = ped-venda.perc-desco1
           f = IF AVAIL ped-item THEN ped-item.val-desconto[1]            ELSE 0
           g = IF AVAIL ped-item THEN ped-item.val-desconto[2]            ELSE 0
           h = IF AVAIL ped-item THEN ped-item.val-desconto[3]            ELSE 0
           i = IF AVAIL ped-item THEN ped-item.val-desconto[4]            ELSE 0
           j = IF AVAIL ped-item THEN ped-item.val-desconto[5]            ELSE 0
           l = IF AVAIL ped-item THEN ped-item.val-pct-desconto-periodo   ELSE 0
           m = IF AVAIL ped-item THEN ped-item.val-pct-desconto-prazo     ELSE 0
           n = IF AVAIL ped-item THEN ped-item.val-pct-desconto-tab-preco ELSE 0  .

    ASSIGN de-liquido = de-liquido - ((de-liquido * c) / 100)
           de-liquido = de-liquido - ((de-liquido * d) / 100)
           de-liquido = de-liquido - ((de-liquido * f) / 100)
           de-liquido = de-liquido - ((de-liquido * g) / 100)
           de-liquido = de-liquido - ((de-liquido * h) / 100)
           de-liquido = de-liquido - ((de-liquido * i) / 100)
           de-liquido = de-liquido - ((de-liquido * j) / 100)
           de-liquido = de-liquido - ((de-liquido * l) / 100)
           de-liquido = de-liquido - ((de-liquido * m) / 100)
           de-liquido = de-liquido - ((de-liquido * n) / 100).
  
END.

/*Procedure para extrair os descontos informados no pedido e tamb‚m no item, */
/* que sÆo informados na forma de formula */
PROCEDURE pi-extrai-descontos:
    DEF INPUT PARAM p-desconto AS CHAR .
    DEF VAR i AS INTEGER NO-UNDO.

    DO  i = 1 TO 20: de-desconto[i] = 0. END.

    DO  i = 1 TO NUM-ENTRIES(p-desconto, "+"):
        ASSIGN de-desconto[i] = dec(ENTRY(i, TRIM(p-desconto), "+")).       
    END.
END.
