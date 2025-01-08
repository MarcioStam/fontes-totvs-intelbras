/********************************************************************************
 ** UPC........: win274.p - UPC WRITE ordem-compra
 ** Data.......: Dezembro ; 2020
 ** Objetivo...:  
 ** Vers∆o.....: 16/11/2022 - Henke/iDBA - Integraá∆o com o ARIBA; 
 ********************************************************************************/
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

DEF NEW GLOBAL SHARED VAR v-rw-es-api-log AS ROWID NO-UNDO.

DEF PARAM BUFFER b-ordem-compra      FOR ordem-compra.
DEF PARAM BUFFER b-old-ordem-compra  FOR ordem-compra.

DEF VAR v-num-seq-movto AS INT NO-UNDO.
DEF VAR de-preco-unit   AS DEC NO-UNDO.
DEF VAR de-total        AS DEC NO-UNDO.
def var i-hora-aux      as int no-undo.

DEF VAR l-msg     AS l NO-UNDO.
DEF VAR i         AS i NO-UNDO.

DEF TEMP-TABLE tt-pedido NO-UNDO
    FIELD num-pedido LIKE pedido-compr.num-pedido.

def new global shared temp-table tt-ordem-esccp052 no-undo
    field it-codigo    like ordem-compra.it-codigo
    field numero-ordem like ordem-compra.numero-ordem
    field qt-solic     like ordem-compra.qt-solic
    index id is primary it-codigo
                        numero-ordem.

{upc/cc0394-upc.i}
{esp/esapi505b.i}

if /*new b-ordem-compra
and*/ can-find(first tt-ordem-esccp052 where
                   tt-ordem-esccp052.it-codigo = b-ordem-compra.it-codigo)
then do:
     for first tt-ordem-esccp052
         where tt-ordem-esccp052.it-codigo    = b-ordem-compra.it-codigo
           and tt-ordem-esccp052.numero-ordem = b-ordem-compra.numero-ordem: end.

     if not avail tt-ordem-esccp052
     then do:
          create tt-ordem-esccp052.
          assign tt-ordem-esccp052.it-codigo    = b-ordem-compra.it-codigo   
                 tt-ordem-esccp052.numero-ordem = b-ordem-compra.numero-ordem.
     end.
     assign tt-ordem-esccp052.qt-solic = b-ordem-compra.qt-solic.
     find current tt-ordem-esccp052 no-error.
     release tt-ordem-esccp052.
end. /* if can-find(first tt-ordem-esccp052 */

if new b-ordem-compra
then do:
     for first tt-cc0394-upc 
         where tt-cc0394-upc.num-pedido-dest = b-ordem-compra.num-pedido
           and tt-cc0394-upc.it-codigo       = b-ordem-compra.it-codigo
           and tt-cc0394-upc.processado      = no: 
         assign tt-cc0394-upc.numero-ordem-dest = b-ordem-compra.numero-ordem
                tt-cc0394-upc.processado        = yes.
     end. /* for first tt-cc0394-upc */

     find current tt-cc0394-upc no-error.
     release tt-cc0394-upc.
end. /* if new b-ordem-compra */
else if  b-ordem-compra.situacao <> 4 /* Eliminada */
     and b-ordem-compra.situacao <> 6 /* Recebida */
     then.
     else do:
          for first tt-cc0394-upc use-index id2
              where tt-cc0394-upc.numero-ordem-orig = b-ordem-compra.numero-ordem
                and tt-cc0394-upc.processado        = yes:
              assign tt-cc0394-upc.validado = yes.
          end. /* for first tt-cc0394-upc */

          find current tt-cc0394-upc no-error.
          release tt-cc0394-upc.
     end. /* else do */

IF b-ordem-compra.pre-unit-for <> b-old-ordem-compra.pre-unit-for
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
            OF b-ordem-compra,                 
         FIRST ext-embarque-imp NO-LOCK         
         WHERE ext-embarque-imp.cod-estabel     = ordens-embarque.cod-estabel
           AND ext-embarque-imp.embarque        = ordens-embarque.embarque
           AND ext-embarque-imp.log-envio-comex = YES:
         RUN pi-output-api-request  ("CEX",
                                     "1",
                                     "ItPedidoCEX-ALT",
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

IF b-ordem-compra.mo-codigo <> b-old-ordem-compra.mo-codigo
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
               OF b-ordem-compra,                 
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

IF NOT NEW b-ordem-compra 
OR v-rw-es-api-log = ? THEN DO:
    IF (b-ordem-compra.data-atualiz <> b-old-ordem-compra.data-atualiz
    OR  b-ordem-compra.hora-atualiz <> b-old-ordem-compra.hora-atualiz)
    AND b-ordem-compra.situacao  <> 4 /* Eliminada */ 
    AND b-ordem-compra.situacao  <> 6 /* Recebida */ THEN DO:
        FIND FIRST int-ped-compr EXCLUSIVE-LOCK
             WHERE int-ped-compr.num-pedido = b-ordem-compra.num-pedido NO-ERROR.
        IF NOT AVAIL int-ped-compr THEN DO:
            FIND FIRST pedido-compr NO-LOCK
                WHERE pedido-compr.num-pedido = b-ordem-compra.num-pedido NO-ERROR.
            IF AVAIL pedido-compr THEN DO:
                CREATE int-ped-compr.
                ASSIGN int-ped-compr.num-pedido   = pedido-compr.num-pedido
                       int-ped-compr.id-ped-compr = NEXT-VALUE (seq_id_ped_compr)
                       int-ped-compr.cod-emitente = pedido-compr.cod-emitente
                       int-ped-compr.responsavel  = pedido-compr.responsavel
                       int-ped-compr.cod-estabel  = pedido-compr.cod-estabel           
                       int-ped-compr.i-moeda      = pedido-compr.i-moeda
                       int-ped-compr.cod-usuar-criac = v_cod_usuar_corren
                       int-ped-compr.dat-criac    = TODAY
                       int-ped-compr.hra-criac    = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")
                       int-ped-compr.ind-status   = 1. //"N∆o Integrado".
                CREATE int-mov-ped-compr.
                ASSIGN int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                       int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                       int-mov-ped-compr.num-seq-movto = 10
                       int-mov-ped-compr.ind-tip-movto = "N∆o Integrado"
                       int-mov-ped-compr.dat-movto     = TODAY
                       int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")
                       int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                       int-mov-ped-compr.des-text-histor = "Criaá∆o do Pedido de Compras: " + STRING (pedido-compr.num-pedido).
                // MESSAGE "criou o int-ped-compr" VIEW-AS ALERT-BOX.
            END.
        END.
        FIND FIRST int-ped-compr EXCLUSIVE-LOCK
             WHERE int-ped-compr.num-pedido = b-ordem-compra.num-pedido NO-ERROR.
        IF AVAIL int-ped-compr THEN DO:
            assign i-hora-aux = 0.
            FIND LAST int-mov-ped-compr NO-LOCK
                 WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
                   AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
            IF AVAIL int-mov-ped-compr THEN
                ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10
                       i-hora-aux      = inte(int-mov-ped-compr.hra-movto)
                       no-error.
            ELSE
                ASSIGN v-num-seq-movto = 20.

         /* Evitar repetiá∆o */
         if  avail int-mov-ped-compr
         and i-hora-aux                      > 0
         and absolute(i-hora-aux - inte(replace(string(TIME,"HH:MM:SS"),":",""))) < 3
         and int-ped-compr.ind-status        = 3
         and int-mov-ped-compr.ind-tip-movto = "Em Revis∆o"
         and int-mov-ped-compr.dat-movto     = today
         and int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
         then.
         else do:
              CREATE int-mov-ped-compr.
              ASSIGN int-ped-compr.ind-status        = 3 // "Em Revis∆o"
                     int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                     int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                     int-mov-ped-compr.num-seq-movto = v-num-seq-movto
                     int-mov-ped-compr.ind-tip-movto = "Em Revis∆o"
                     int-mov-ped-compr.dat-movto     = TODAY
                     int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")               
                     int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                     int-mov-ped-compr.des-text-histor = "Pedido de Compras Alterado: " + STRING (b-ordem-compra.num-pedido).
              /*
              MESSAGE "Ordem Seq: " int-mov-ped-compr.num-seq-movto SKIP
                      "Movto: " int-mov-ped-compr.ind-tip-movto VIEW-AS ALERT-BOX.
              */
            end. /* else do */
        END.
        RUN pi-val-total.
    END.
    IF b-old-ordem-compra.situacao <> b-ordem-compra.situacao THEN DO:
        IF b-old-ordem-compra.situacao = 4 /* Eliminada */ THEN DO:
            IF NOT CAN-FIND (FIRST ordem-compra NO-LOCK
                         WHERE ordem-compra.num-pedido = b-ordem-compra.num-pedido
                           AND ordem-compra.numero-ordem <> b-ordem-compra.numero-ordem) THEN DO:
                RETURN.
            END.
        END.

        IF  b-ordem-compra.situacao = 4 /* Eliminada */
        AND can-find(FIRST pedido-compr where
                           pedido-compr.num-pedido = b-ordem-compra.num-pedido
                       AND pedido-compr.situacao   = 3 /* Eliminado */
                           NO-LOCK)
        THEN RETURN.

        IF  b-old-ordem-compra.num-pedido <> 0
        AND b-ordem-compra.num-pedido      = 0
        THEN FIND FIRST int-ped-compr EXCLUSIVE-LOCK
                  WHERE int-ped-compr.num-pedido = b-old-ordem-compra.num-pedido NO-ERROR.
        ELSE FIND FIRST int-ped-compr EXCLUSIVE-LOCK
                  WHERE int-ped-compr.num-pedido = b-ordem-compra.num-pedido NO-ERROR.
        IF AVAIL int-ped-compr THEN DO:
            assign i-hora-aux = 0.
            FIND LAST int-mov-ped-compr NO-LOCK
                 WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
                   AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
            IF AVAIL int-mov-ped-compr THEN
                ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10
                       i-hora-aux      = inte(int-mov-ped-compr.hra-movto)
                       no-error.
            ELSE
                ASSIGN v-num-seq-movto = 20.

            /* Evitar repetiá∆o */
            if  avail int-mov-ped-compr
            and i-hora-aux                      > 0
            and absolute(i-hora-aux - inte(replace(string(TIME,"HH:MM:SS"),":",""))) < 3
            and int-ped-compr.ind-status        = 3
            and int-mov-ped-compr.ind-tip-movto = "Em Revis∆o"
            and int-mov-ped-compr.dat-movto     = today
            and int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
            then.
            else do:
                 CREATE int-mov-ped-compr.
                 ASSIGN int-ped-compr.ind-status        = 3 // "Em Revis∆o"
                        int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                        int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                        int-mov-ped-compr.num-seq-movto = v-num-seq-movto
                        int-mov-ped-compr.ind-tip-movto = "Em Revis∆o"
                        int-mov-ped-compr.dat-movto     = TODAY
                        int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")               
                        int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                        int-mov-ped-compr.des-text-histor = "Pedido de Compras Alterado: " + STRING (int-ped-compr.num-pedido).
            end. /* else do */
        END.
        RUN pi-val-total.
    END.
END.

find current int-ped-compr     no-lock no-error.
find current int-mov-ped-compr no-lock no-error.
release int-ped-compr.
release int-mov-ped-compr.

RETURN "ok".

PROCEDURE pi-val-total:

/*     FIND FIRST int-ped-compr EXCLUSIVE-LOCK                                   */
/*          WHERE int-ped-compr.num-pedido = b-ordem-compra.num-pedido NO-ERROR. */
    IF AVAIL int-ped-compr THEN DO:
        ASSIGN de-preco-unit = 0.
        FOR EACH ordem-compra USE-INDEX pedido no-lock
            WHERE ordem-compra.num-pedido = int-ped-compr.num-pedido:
            IF ordem-compra.situacao = 4 /* Eliminada */ THEN
                NEXT.
            ASSIGN de-preco-unit = ordem-compra.preco-unit.
            IF ordem-compra.mo-codigo <> 0 /* Real */ THEN DO:
                FIND FIRST cotacao-item OF ordem-compra NO-LOCK NO-ERROR.
                RUN cdp/cd0812.p (INPUT ordem-compra.mo-codigo,
                                  INPUT 0,
                                  INPUT de-preco-unit,
                                  INPUT IF AVAIL cotacao-item THEN cotacao-item.data-cotacao ELSE ordem-compra.data-pedido,
                                  OUTPUT de-preco-unit).
            END.
            FOR EACH prazo-compra USE-INDEX ordem NO-LOCK
                WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                IF prazo-compra.situacao = 4 THEN
                    NEXT.
                ASSIGN de-total = de-total + (prazo-compra.quantidade * de-preco-unit).
            END.
        END.
        if de-total <> ?
        then ASSIGN int-ped-compr.val-total = ROUND (de-total, 2).
    END.

END.
