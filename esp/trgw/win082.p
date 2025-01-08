/********************************************************************************
 ** UPC........: win122.p - UPC WRITE cotacao-item
 ** Data.......: Novembro / 2009
 ** Objetivo...: Cria tabela int-cotacao-item
 
 compile \\tsclient\c\fontes\esp\trgw\win172.p save into c:\temp\esp\trgw.
 
 ********************************************************************************/

DEF PARAM BUFFER b-cotacao-item      FOR cotacao-item.
DEF PARAM BUFFER b-old-cotacao-item  FOR cotacao-item.

DEF TEMP-TABLE tt-pedido NO-UNDO
    FIELD num-pedido LIKE pedido-compr.num-pedido.

DEF VAR l-msg     AS l NO-UNDO.
DEF VAR i         AS i NO-UNDO.

{esp/esapi505b.i}  

/* a trigger de write foi substituida pelas triggers de assign. */
DEFINE VARIABLE l-encontrou AS LOGICAL     NO-UNDO.

IF NEW b-cotacao-item THEN do:
    FIND FIRST int-cotacao-item OF b-cotacao-item NO-LOCK NO-ERROR.
    IF NOT AVAIL int-cotacao-item THEN DO:
        CREATE int-cotacao-item.
        ASSIGN int-cotacao-item.numero-ordem = b-cotacao-item.numero-ordem
               int-cotacao-item.cod-emitente = b-cotacao-item.cod-emitente
               int-cotacao-item.it-codigo    = b-cotacao-item.it-codigo
               int-cotacao-item.seq-cotac    = b-cotacao-item.seq-cotac.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = b-cotacao-item.it-codigo NO-ERROR.
        IF AVAIL ITEM THEN DO:
            FIND FIRST int-item NO-LOCK
                 WHERE int-item.it-codigo = ITEM.it-codigo NO-ERROR.
            IF AVAIL int-item THEN DO:
                ASSIGN int-cotacao-item.destaque         = int-item.destaque
                       int-cotacao-item.log-necessita-li = item.log-necessita-li
                       int-cotacao-item.log-gatt         = int-item.log-gatt
                       int-cotacao-item.perc-gatt        = int-item.perc-gatt.

            END.
        END.
    END.
END. 

ELSE DO:
   IF b-cotacao-item.mo-codigo <> b-old-cotacao-item.mo-codigo
   THEN DO:
      /*DO i = 1 TO 10:
         IF PROGRAM-NAME(i) MATCHES "MSG" 
         THEN DO:
            ASSIGN
               l-msg = YES.
            LEAVE.
         END.
      END.
   
      IF l-msg = NO
      THEN*/ DO:
         FOR EACH ordens-embarque NO-LOCK
            WHERE ordens-embarque.numero-ordem     = b-cotacao-item.numero-ordem,
            FIRST ordem-compra    NO-LOCK          
               OF ordens-embarque,                 
            FIRST ext-embarque-imp NO-LOCK         
            WHERE ext-embarque-imp.cod-estabel     = ordens-embarque.cod-estabel
              AND ext-embarque-imp.embarque        = ordens-embarque.embarque
              AND ext-embarque-imp.log-envio-comex = YES:
            FIND FIRST tt-pedido
                 WHERE tt-pedido.num-pedido = ordem-compra.num-pedido
                 NO-ERROR.
            IF NOT AVAIL tt-pedido
            THEN DO:
               CREATE tt-pedido.
               ASSIGN
                  tt-pedido.num-pedido = ordem-compra.num-pedido.
               RUN pi-output-api-request  ("CEX",
                                           "1",
                                           "PedidoCEX-ALT",
                                           "TRIGGER",
                                           ordens-embarque.cod-estabel          + "," + 
                                           ordens-embarque.embarque             + "," + 
                                           STRING(ordens-embarque.numero-ordem) + "," + 
                                           STRING(ordens-embarque.parcela),
                                           lcRequest
                                          ).
            END.
         END.
      END.
   END.
END.
/***************************************************************************************
*** Valida o itiner rio da Ordem com o itiner rio do Processo de Importa‡Æo(Pedido)  ***
****************************************************************************************/
/* for first ordem-compra no-lock */
/*     where ordem-compra.numero-ordem = b-cotacao-item.numero-ordem: */
/*    */
/*     find first processo-imp no-lock */
/*         where processo-imp.num-pedido = ordem-compra.num-pedido no-error. */
/*    */
/*     if avail processo-imp */
/*          and processo-imp.cod-itiner <> b-cotacao-item.int-1 then do: */
/*    */
/*             RUN utp\ut-msgs.p (INPUT "SHOW", */
/*                                INPUT 27979, */
/*                                INPUT "ATEN€ÇO: Itiner rios divergentes!~~Itiner rio " + string(b-cotacao-item.int-1) + */
/*                                          " da Ordem, difere do itiner rio do Processo de Importa‡Æo: " + string(processo-imp.cod-itiner) + "."). */
/*     end. */
/* end. */
