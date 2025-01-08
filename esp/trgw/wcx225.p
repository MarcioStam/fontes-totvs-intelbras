/********************************************************************************
 ** UPC........: wcx225.p - UPC WRITE ordens-embarque
 ** Data.......: Julho / 2021
 ** Objetivo...: Disparar Integra‡Æo com o DATI
 
 ********************************************************************************/

DEF PARAM BUFFER b-ordens-embarque      FOR ordens-embarque.
DEF PARAM BUFFER b-old-ordens-embarque  FOR ordens-embarque.

DEF BUFFER b-ordem-compra FOR ordem-compra.

DEFINE VARIABLE i AS INTEGER     NO-UNDO.

{esp/esapi505b.i}  

FIND FIRST ext-embarque-imp NO-LOCK /* Verifica se o embarque foi para o DATI */
     WHERE ext-embarque-imp.cod-estabel     = b-ordens-embarque.cod-estabel 
       AND ext-embarque-imp.embarque        = b-ordens-embarque.embarque 
       AND ext-embarque-imp.log-envio-comex = YES NO-ERROR. 
IF AVAIL ext-embarque-imp THEN DO:
   IF NEW b-ordens-embarque THEN DO:
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
                                     "PedidoCEX-NEW",
                                     "WCX225",
                                     ext-embarque-imp.cod-estabel           + "," + 
                                     ext-embarque-imp.embarque              + "," + 
                                     STRING(b-ordens-embarque.numero-ordem) + "," + 
                                     STRING(b-ordens-embarque.parcela),
                                     lcRequest
                                    ).
      ELSE
         RUN pi-output-api-request  ("CEX",
                                     "1",
                                     "ItPedidoCEX-NEW",
                                     "WCX225",
                                     ext-embarque-imp.cod-estabel           + "," + 
                                     ext-embarque-imp.embarque              + "," + 
                                     STRING(b-ordens-embarque.numero-ordem) + "," + 
                                     STRING(b-ordens-embarque.parcela),
                                     lcRequest
                                    ).
   
   END.
   ELSE DO:
      IF b-ordens-embarque.quantidade <> b-old-ordens-embarque.quantidade THEN DO:
          RUN pi-output-api-request  ("CEX",
                                      "1",
                                      "ItPedidoCEX-ALT",
                                      "WCX225",
                                      ext-embarque-imp.cod-estabel               + "," + 
                                      ext-embarque-imp.embarque                  + "," + 
                                      STRING(b-ordens-embarque.numero-ordem) + "," + 
                                      STRING(b-ordens-embarque.parcela),
                                      lcRequest
                                     ).
      END.
   END.
END.



