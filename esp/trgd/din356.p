/********************************************************************************
 ** UPC........: din356.p - UPC DELETE prazo-compra
 ** Data.......: 06/03/2023
 ** Objetivo...: M¢dulo Commerce
 ********************************************************************************/

def param buffer bff-prazo-compra for prazo-compra.

DEF BUFFER bff-ordem-compra   FOR ordem-compra.
DEF BUFFER b-prazo-compra-aux FOR prazo-compra.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.
DEF VAR v-num-seq-movto AS INT NO-UNDO.
def var i-hora-aux      as int no-undo.

for first int-prazo-compra exclusive-lock
    where int-prazo-compra.numero-ordem = bff-prazo-compra.numero-ordem
      AND int-prazo-compra.parcela      = bff-prazo-compra.parcela:
    delete int-prazo-compra.
end.

FOR FIRST ordem-compra
    WHERE ordem-compra.numero-ordem = bff-prazo-compra.numero-ordem
      AND ordem-compra.situacao    <> 4
          NO-LOCK: END.

IF  AVAIL ordem-compra
AND CAN-FIND(FIRST int-ped-compr WHERE
                   int-ped-compr.num-pedido  = ordem-compra.num-pedido
                   NO-LOCK)
AND CAN-FIND (FIRST pedido-compr where
                    pedido-compr.num-pedido = ordem-compra.num-pedido
                    no-lock)
AND NOT CAN-FIND(FIRST pedido-compr WHERE
                       pedido-compr.num-pedido = ordem-compra.num-pedido
                   AND pedido-compr.situacao   = 3
                       NO-LOCK)
THEN DO:
     FOR FIRST int-ped-compr EXCLUSIVE-LOCK
         WHERE int-ped-compr.num-pedido = ordem-compra.num-pedido:
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

         /* Evitar repeti‡Æo */
         if  avail int-mov-ped-compr
         and i-hora-aux                      > 0
         and absolute(i-hora-aux - inte(replace(string(TIME,"HH:MM:SS"),":",""))) < 3
         and int-ped-compr.ind-status        = 3
         and int-mov-ped-compr.ind-tip-movto = "Em RevisÆo"
         and int-mov-ped-compr.dat-movto     = today
         and int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
         then.
         else do:
              CREATE int-mov-ped-compr.
              ASSIGN int-ped-compr.ind-status        = 3 // "Em RevisÆo"
                     int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                     int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                     int-mov-ped-compr.num-seq-movto = v-num-seq-movto
                     int-mov-ped-compr.ind-tip-movto = "Em RevisÆo"
                     int-mov-ped-compr.dat-movto     = TODAY
                     int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")               
                     int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                     int-mov-ped-compr.des-text-histor = "Pedido de Compras Alterado: " + STRING (ordem-compra.num-pedido).
         end. /* else do */

         RUN pi-val-total.
     END. /* FOR FIRST int-ped-compr */

     FIND CURRENT int-ped-compr NO-LOCK NO-ERROR.
     FIND CURRENT int-mov-ped-compr NO-LOCK NO-ERROR.
     RELEASE int-ped-compr.
     RELEASE int-mov-ped-compr.
END. /* if avail ordem-compra */

/********** PROCEDURES **********/
PROCEDURE pi-val-total:
    DEF VAR de-preco-unit AS DEC NO-UNDO.
    DEF VAR de-total      AS DEC NO-UNDO.

    ASSIGN de-total = 0.
    FOR EACH bff-ordem-compra USE-INDEX pedido NO-LOCK
        WHERE bff-ordem-compra.num-pedido = ordem-compra.num-pedido
          AND bff-ordem-compra.situacao  <> 4:
        ASSIGN de-preco-unit = bff-ordem-compra.preco-unit.
        IF bff-ordem-compra.mo-codigo <> 0 /* Real */ THEN DO:
            FIND FIRST cotacao-item OF bff-ordem-compra NO-LOCK NO-ERROR.
            RUN cdp/cd0812.p (INPUT bff-ordem-compra.mo-codigo,
                              INPUT 0,
                              INPUT de-preco-unit,
                              INPUT IF AVAIL cotacao-item THEN cotacao-item.data-cotacao ELSE bff-ordem-compra.data-pedido,
                              OUTPUT de-preco-unit).
        END.
        FOR EACH b-prazo-compra-aux USE-INDEX ordem NO-LOCK
            WHERE b-prazo-compra-aux.numero-ordem = bff-ordem-compra.numero-ordem
              AND b-prazo-compra-aux.situacao    <> 4
              AND ROWID(b-prazo-compra-aux)      <> ROWID(bff-prazo-compra):
            ASSIGN de-total = de-total + (b-prazo-compra-aux.quantidade * de-preco-unit).
        END.
    END.
    IF de-total <> ?
    THEN ASSIGN int-ped-compr.val-total = ROUND (de-total, 2).

    RETURN "OK".
END PROCEDURE.
