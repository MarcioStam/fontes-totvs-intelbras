/********************************************************************************
 ** UPC........: dcx220.p - DELETE ordens-embarque
 ** Data.......: Julho / 2021
 ** Objetivo...: Disparar Integra‡Æo com o DATI
 ********************************************************************************/

DEF PARAM BUFFER b-ordens-embarque FOR ordens-embarque.
DEF BUFFER b-ordem-compra FOR ordem-compra.

DEFINE VARIABLE i AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-desembarque AS LOGICAL     NO-UNDO.

{esp/esapi505b.i}  

FIND FIRST ext-embarque-imp EXCLUSIVE-LOCK /* Verifica se o embarque foi para o DATI */
     WHERE ext-embarque-imp.cod-estabel     = b-ordens-embarque.cod-estabel 
       AND ext-embarque-imp.embarque        = b-ordens-embarque.embarque 
       AND ext-embarque-imp.log-envio-comex = YES NO-ERROR. 
IF AVAIL ext-embarque-imp THEN DO:
    
    ASSIGN l-desembarque = NO.

    FOR EACH  historico-embarque NO-LOCK
        WHERE historico-embarque.cod-estabel = ext-embarque-imp.cod-estabel
          AND historico-embarque.embarque    = ext-embarque-imp.embarque,
        FIRST itinerario OF historico-embarque NO-LOCK
        WHERE itinerario.pto-desembarque = historico-embarque.cod-pto-contr.
    
        IF historico-embarque.dt-efetiva NE ? THEN
            ASSIGN l-desembarque = YES.                    
    END.    

    IF NOT l-desembarque THEN DO:

        FIND FIRST ordens-embarque NO-LOCK /* Verifica se ‚ a ultima parcela do embarque */
             WHERE ordens-embarque.cod-estabel  = ext-embarque-imp.cod-estabel
               AND ordens-embarque.embarque     = ext-embarque-imp.embarque
               AND ROWID(ordens-embarque)      <> rowid(b-ordens-embarque) NO-ERROR.
        IF NOT AVAIL ordens-embarque THEN DO:
           RUN pi-output-api-request  ("CEX",
                                       "1",
                                       "ProcessoCEX-DEL",
                                       "DCX225",
                                       ext-embarque-imp.embarque,
                                       lcRequest
                                      ).
           ASSIGN ext-embarque-imp.log-envio-comex = NO
                  ext-embarque-imp.log-enviado-comex = NO.
        END.
        ELSE DO:
           ASSIGN i = 0.
           FIND FIRST ordem-compra NO-LOCK
                WHERE ordem-compra.numero-ordem  = b-ordens-embarque.numero-ordem NO-ERROR.
           FIND FIRST pedido-compr NO-LOCK
                WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.
           FOR EACH b-ordem-compra NO-LOCK
              WHERE b-ordem-compra.num-pedido      = ordem-compra.num-pedido,
               EACH ordens-embarque NO-LOCK
              WHERE ordens-embarque.numero-ordem = b-ordem-compra.numero-ordem
                AND ordens-embarque.embarque     = b-ordens-embarque.embarque
                AND ROWID(ordens-embarque)      <> rowid(b-ordens-embarque):
              ASSIGN i = i + 1.
           END.
           IF i = 0 THEN
              RUN pi-output-api-request  ("CEX",
                                          "1",
                                          "PedidoCEX-DEL",
                                          "DCX225",
                                          b-ordens-embarque.embarque + "-" + STRING(ordem-compra.num-pedido),
                                          lcRequest).
           ELSE
              RUN pi-output-api-request  ("CEX",
                                          "1",
                                          "ItPedidoCEX-DEL",
                                          "DCX225",
                                          b-ordens-embarque.embarque + "-" + STRING(ordem-compra.num-pedido) + "-" + STRING(b-ordens-embarque.numero-ordem) + "-" + STRING(b-ordens-embarque.parcela) + "-" + ordem-compra.it-codigo + "-" + STRING(pedido-compr.cod-emitente),
                                          lcRequest).
        
        
        END.
    END.
END.
RELEASE ext-embarque-imp.



