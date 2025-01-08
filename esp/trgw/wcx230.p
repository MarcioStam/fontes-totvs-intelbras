/********************************************************************************
 ** UPC........: wcx230.p - UPC WRITE historico-embarque
 ** Data.......: Junho / 2021
 ** Objetivo...: 
 ********************************************************************************/
{utp/ut-glob.i}

DEF PARAM BUFFER new-historico-embarque  FOR historico-embarque.
DEF PARAM BUFFER old-historico-embarque  FOR historico-embarque.

    DEFINE VARIABLE c-time AS CHARACTER   NO-UNDO.

IF NOT NEW new-historico-embarque THEN DO:
   IF old-historico-embarque.dt-ult-previsao <> new-historico-embarque.dt-ult-previsao THEN DO:
      FIND FIRST embarque-imp NO-LOCK
           WHERE embarque-imp.cod-estabel    = new-historico-embarque.cod-estabel
             AND embarque-imp.embarque       = new-historico-embarque.embarque
             AND embarque-imp.cdn-pto-chegad = new-historico-embarque.cod-pto-contr NO-ERROR.
      IF AVAIL embarque-imp THEN DO:
         FOR EACH ordens-embarque FIELDS(nr-proc-imp numero-ordem parcela cod-estabel)
             WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
               AND ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK:
         
             FOR FIRST prazo-compra USE-INDEX ordem
                  WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem
                    AND prazo-compra.parcela      = ordens-embarque.parcela NO-LOCK:
             END.
             IF AVAIL prazo-compra THEN
             
                 IF new-historico-embarque.dt-ult-previsao <> prazo-compra.data-entrega THEN DO:
                           
                     FIND CURRENT prazo-compra EXCLUSIVE-LOCK NO-ERROR.
             
                     /*FO: 1806.191 Modifica‡äes para Criar a alt-ped*/
                     find first ordem-compra where ordem-compra.numero-ordem = prazo-compra.numero-ordem exclusive-lock no-error.
                         {cxbo/bocx140.i03 today
                             c-seg-usuario
                             ordem-compra.num-pedido
                             ordem-compra.numero-ordem 
                             prazo-compra.parcela
                             prazo-compra.data-entrega
                             ?
                             ?
                             ordem-compra.cod-emitente
                             ordem-compra.gera-edi
                             ordem-compra.num-pedido
                             new-historico-embarque.dt-ult-previsao }   
                     /*Fim FO: 1806.191 */
                     ASSIGN prazo-compra.data-entrega = new-historico-embarque.dt-ult-previsao.
                 END.
      
             RELEASE prazo-compra.
             RELEASE ordem-compra.
             RELEASE alt-ped.
         END.
      END.
   END.
END.

