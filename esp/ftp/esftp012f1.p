DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE INPUT PARAM p-log-aloca   AS LOG.
DEFINE INPUT PARAM p-nr-pedido   LIKE it-ped-fiscal.nr-pedido.
DEFINE INPUT PARAM p-it-codigo   LIKE it-ped-fiscal.it-codigo.
DEFINE INPUT PARAM p-seq         LIKE it-ped-fiscal.seq.
DEFINE INPUT PARAM p-cod-estabel LIKE ped-fiscal.cod-estabel.
DEFINE INPUT PARAM p-cod-localiz LIKE it-ped-fiscal.cod-localiz.
DEFINE INPUT PARAM p-cod-depos   LIKE it-ped-fiscal.cod-depos.
DEFINE INPUT PARAM p-lote        LIKE int-saldo-aloc-lote.lote.
DEFINE INPUT PARAM p-qtde-alocar AS DEC.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.

DEFINE VARIABLE de-saldo AS DECIMAL     NO-UNDO.

DEFINE BUFFER b-int-saldo-aloc-lote FOR int-saldo-aloc-lote.

DO TRANS:

    /*desfaz a alocaá∆o caso j† exista para depois refazer*/
    FOR EACH int-saldo-aloc-lote EXCLUSIVE-LOCK
       WHERE int-saldo-aloc-lote.nr-pedido = p-nr-pedido
         AND int-saldo-aloc-lote.it-codigo = p-it-codigo
         AND int-saldo-aloc-lote.seq       = p-seq:
    
        FOR FIRST saldo-estoq EXCLUSIVE-LOCK
            WHERE saldo-estoq.it-codigo   = int-saldo-aloc-lote.it-codigo
              AND saldo-estoq.cod-estabel = p-cod-estabel
              AND saldo-estoq.cod-localiz = int-saldo-aloc-lote.cod-localiz
              AND saldo-estoq.cod-depos   = int-saldo-aloc-lote.cod-depos
              AND saldo-estoq.lote        = int-saldo-aloc-lote.lote:
    
            ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada - int-saldo-aloc-lote.qtidade-atu.
        END.

        release saldo-estoq.
    
        DELETE int-saldo-aloc-lote.
    END.
    
    IF p-log-aloca THEN DO:
        
        DO TRANSACTION
        ON ERROR UNDO,LEAVE
        ON STOP UNDO, LEAVE:
            FOR EACH saldo-estoq EXCLUSIVE-LOCK
                WHERE saldo-estoq.it-codigo   = p-it-codigo
                  AND saldo-estoq.cod-estabel = p-cod-estabel
                  AND saldo-estoq.cod-localiz = p-cod-localiz
                  AND saldo-estoq.cod-depos   = p-cod-depos
                  AND saldo-estoq.lote        = p-lote
                   BY saldo-estoq.dt-vali-lote:

                
                ASSIGN de-saldo = saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - saldo-estoq.qt-aloc-prod.

                IF de-saldo = 0 THEN NEXT. /* so aloca de lote com saldo*/
            
                /*Se tem saldo para atender a quantidade a alocar restante*/
                IF de-saldo >= p-qtde-alocar THEN DO:

                    CREATE b-int-saldo-aloc-lote.
                    ASSIGN b-int-saldo-aloc-lote.seq         = p-seq
                           b-int-saldo-aloc-lote.qtidade-atu = p-qtde-alocar
                           b-int-saldo-aloc-lote.nr-pedido   = p-nr-pedido
                           b-int-saldo-aloc-lote.lote        = saldo-estoq.lote
                           b-int-saldo-aloc-lote.it-codigo   = p-it-codigo
                           b-int-saldo-aloc-lote.cod-depos   = p-cod-depos
                           b-int-saldo-aloc-lote.cod-localiz = p-cod-localiz.
            
                    ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + p-qtde-alocar
                           p-qtde-alocar = 0.
                    
                END.
                ELSE IF de-saldo > 0 THEN DO:
                            
                    CREATE b-int-saldo-aloc-lote.
                    ASSIGN b-int-saldo-aloc-lote.seq         = p-seq
                           b-int-saldo-aloc-lote.qtidade-atu = de-saldo
                           b-int-saldo-aloc-lote.nr-pedido   = p-nr-pedido
                           b-int-saldo-aloc-lote.lote        = saldo-estoq.lote
                           b-int-saldo-aloc-lote.it-codigo   = p-it-codigo
                           b-int-saldo-aloc-lote.cod-depos   = p-cod-depos
                           b-int-saldo-aloc-lote.cod-localiz = p-cod-localiz.
            
                    ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + de-saldo
                           p-qtde-alocar = p-qtde-alocar - de-saldo.
                END.
            
                IF p-qtde-alocar = 0 THEN
                    LEAVE.
    
            END. /*FOR EACH saldo-estoq NO-LOCK*/

            if avail saldo-estoq 
            then release saldo-estoq.
    
            /*Se sobrou saldo, o saldo n∆o era suficiente, desfaz e da erro*/
            IF p-qtde-alocar > 0 THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "Item " + p-it-codigo + " n∆o possui saldo suficiente para alocaá∆o.".
                UNDO, LEAVE.
            END.
        END.
    END.
    
END.

