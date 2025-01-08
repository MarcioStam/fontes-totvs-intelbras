/*************************************************************************************
**
**  Programa...: ESCEP005RPC.p
**  Defini‡Æo..: Programa rodado no AppServer para retornar dados para o ESCEP005.
**  Autor......: Anderson Silvano
**  Data.......: 29/09/2005
**
**************************************************************************************/
def temp-table tt-aes
    field nr-ae         AS int  format ">>>>>>9"    label "AE"
    field sequencia     AS int  format ">>9"        label "Seq"
    field quantidade    AS int  format ">>>,>>9"    label "QTD"
    field data          LIKE ae-item.data           label "Data" 
    field cod-depos     AS char format "x(3)"       label "Dep"
    field localizacao   LIKE ae-item.localizacao    label "Local"
    field roteiro       LIKE ae-item.roteiro.

DEF TEMP-TABLE tt-saldo
    FIELD cod-depos     LIKE saldo-estoq.cod-depos   label "Dep"
    FIELD cod-localiz   LIKE saldo-estoq.cod-localiz label "Local"      format "x(8)"
    FIELD quantidade    AS DEC                       label "Quantidade" format "->>>>,>>9.99".    

def input param pi-cod-estabel as char no-undo.
DEF INPUT PARAM p-it-codigo     LIKE ITEM.it-codigo.
DEF INPUT PARAM p-cod-depos-ini LIKE deposito.cod-depos.
DEF INPUT PARAM p-cod-depos-fim LIKE deposito.cod-depos.
DEF INPUT PARAM p-tipo          AS INT.
DEF OUTPUT PARAM de-quantidade  AS DECIMAL FORMAT "->>,>>>,>>9.99".
DEF OUTPUT PARAM de-saldo       AS DECIMAL FORMAT "->>,>>>,>>9.99".
DEF OUTPUT PARAM de-saldo-rec   AS DECIMAL FORMAT "->>,>>>,>>9.99".
DEF OUTPUT PARAM i-saldo-alm    AS DECIMAL FORMAT "->>,>>>,>>9.99".
DEF OUTPUT PARAM c-cod-localiz  LIKE ITEM.cod-localiz.
DEF OUTPUT PARAM TABLE FOR tt-aes.
DEF OUTPUT PARAM TABLE FOR tt-saldo.

EMPTY TEMP-TABLE tt-aes.
EMPTY TEMP-TABLE tt-saldo.

DEF BUFFER bae-item FOR ae-item.
DEF BUFFER bsaldo-estoq FOR saldo-estoq.

ASSIGN de-quantidade = 0
       i-saldo-alm   = 0.    

RELEASE ae-item.
RELEASE saldo-estoq.

IF p-tipo = 1 then do:
    for each ae-item no-lock
        where ae-item.cod-estabel = pi-cod-estabel
        and   ae-item.it-codigo  = p-it-codigo     
        and   ae-item.situacao   = NO 
        and   ae-item.cod-depos >= p-cod-depos-ini
        and   ae-item.cod-depos <= p-cod-depos-fim
        break by ae-item.data
              by ae-item.localizacao:

        FIND FIRST bae-item WHERE ROWID(bae-item) = ROWID(ae-item) NO-LOCK NO-ERROR.
	    FIND CURRENT bae-item NO-LOCK NO-ERROR.

    
        create tt-aes.
        assign tt-aes.nr-ae       = bae-item.nr-ae
               tt-aes.sequencia   = bae-item.sequencia
               tt-aes.quantidade  = bae-item.quantidade
               tt-aes.data        = bae-item.data
               tt-aes.localizacao = bae-item.localizacao
               tt-aes.cod-depos   = bae-item.cod-depos
               tt-aes.roteiro     = bae-item.roteiro.
        assign de-quantidade = de-quantidade + bae-item.quantidade.
    end.
end.
else do:
    for each ae-item no-lock
        where ae-item.cod-estabel = pi-cod-estabel
        and   ae-item.it-codigo  = p-it-codigo     
        and   ae-item.situacao   = NO 
        and   ae-item.cod-depos >= p-cod-depos-ini
        and   ae-item.cod-depos <= p-cod-depos-fim
        break by ae-item.nr-ae
              by ae-item.localizacao:
    
        if first-of(ae-item.localizacao) then do:

            FIND FIRST bae-item WHERE ROWID(bae-item) = ROWID(ae-item) NO-LOCK NO-ERROR.
	        FIND CURRENT bae-item NO-LOCK NO-ERROR.

            create tt-aes.
            assign tt-aes.nr-ae         = bae-item.nr-ae
                   tt-aes.data          = bae-item.data
                   tt-aes.localizacao   = bae-item.localizacao
                   tt-aes.cod-depos     = bae-item.cod-depos
                   tt-aes.roteiro       = bae-item.roteiro.
        end.

        assign tt-aes.quantidade = tt-aes.quantidade + 1
               de-quantidade     = de-quantidade     + 1.
    end.
end.
     
ASSIGN de-saldo = 0
       de-saldo-rec = 0.

FOR EACH saldo-estoq NO-LOCK
   WHERE saldo-estoq.it-codigo    = p-it-codigo
     and saldo-estoq.cod-estabel  = pi-cod-estabel
     AND saldo-estoq.qtidade-atu <> 0:

    FIND FIRST bsaldo-estoq WHERE ROWID(bsaldo-estoq) = ROWID(saldo-estoq) NO-LOCK NO-ERROR.
	FIND CURRENT bsaldo-estoq NO-LOCK NO-ERROR.

    CREATE tt-saldo.
    ASSIGN tt-saldo.cod-depos     = bsaldo-estoq.cod-depos   
           tt-saldo.cod-localiz   = bsaldo-estoq.cod-localiz 
           tt-saldo.quantidade    = (bsaldo-estoq.qtidade-atu - bsaldo-estoq.qt-alocada).

    CASE bsaldo-estoq.cod-depos:
        WHEN "alm" THEN ASSIGN de-saldo     = de-saldo     + bsaldo-estoq.qtidade-atu. 
        WHEN "rec" THEN ASSIGN de-saldo-rec = de-saldo-rec + bsaldo-estoq.qtidade-atu.
    END CASE.

    IF  bsaldo-estoq.cod-depos >= p-cod-depos-ini
    AND bsaldo-estoq.cod-depos <= p-cod-depos-fim THEN
        ASSIGN i-saldo-alm = i-saldo-alm + (bsaldo-estoq.qtidade-atu - bsaldo-estoq.qt-alocada).    
END.

FIND FIRST item-uni-estab NO-LOCK
     WHERE item-uni-estab.cod-estabel = pi-cod-estabel
       AND item-uni-estab.it-codigo   = p-it-codigo NO-ERROR.
IF AVAIL item-uni-estab THEN
    ASSIGN c-cod-localiz = item-uni-estab.cod-localiz.
ELSE DO:
    FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = p-it-codigo NO-ERROR. 
    ASSIGN c-cod-localiz = IF AVAIL ITEM THEN ITEM.cod-localiz ELSE "".
END.
