DEF NEW GLOBAL SHARED VAR whBtAdd      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbrEntregas AS WIDGET-HANDLE NO-UNDO.


IF whBtAdd:SENSITIVE = YES THEN
DO:
/*
    FOR FIRST saldo-estoq 
        WHERE saldo-estoq.cod-estabel = "1"
        AND   saldo-estoq.cod-depos   = "EXP"
        AND   saldo-estoq.it-codigo   = "4070356"
        AND   saldo-estoq.cod-localiz = "E04B-A05":
/*        AND   saldo-estoq.it-codigo   = "4070348"
        AND   saldo-estoq.cod-localiz = "E11B-A14":*/
        MESSAGE saldo-estoq.qtidade-atu SKIP saldo-estoq.qtidade-atu + 1
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ASSIGN /*"341"*/ saldo-estoq.qtidade-atu = saldo-estoq.qtidade-atu + 1.
        /*AND  (saldo-estoq.qtidade-atu - 
             (saldo-estoq.qt-alocada  + bsaldo-estoq.qt-aloc-ped +  bsaldo-estoq.qt-aloc-prod)) >= pQtTransf,*/
    END.*/

/*    apply 'value-changed':U to whbrEntregas.*/


    APPLY "CHOOSE" TO whBtAdd.
END.
