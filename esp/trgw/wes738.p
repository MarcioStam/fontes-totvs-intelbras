TRIGGER PROCEDURE FOR WRITE OF int-ped-venda2 OLD BUFFER b-old-int-ped-venda2.

IF NOT NEW int-ped-venda2 THEN do:  
    
    IF int-ped-venda2.int-1 <> b-old-int-ped-venda2.int-1 THEN DO:

        FOR FIRST ped-venda FIELDS(nr-pedido cod-priori)
            WHERE ped-venda.nr-pedido = int-ped-venda2.nr-pedido
                  NO-LOCK,
            EACH ped-item fields(nat-operacao cod-sit-item it-codigo dt-entrega qt-pedida qt-atendida) OF ped-venda 
                 NO-LOCK:

            /*
            /*considerar somente os pedidos que geram titulo*/
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

            IF  ped-venda.cod-priori <> 44 
            AND natur-oper.emite-duplic 
            AND (ped-item.cod-sit-item <= 2 OR ped-item.cod-sit-item = 5) THEN DO:

                FOR FIRST int-pv-canal 
                    WHERE int-pv-canal.cod-canal = b-old-int-ped-venda2.int-1
                      AND int-pv-canal.it-codigo = ped-item.it-codigo
                      AND int-pv-canal.mes-meta  = MONTH(ped-item.dt-entrega)
                      AND int-pv-canal.ano-meta  = YEAR(ped-item.dt-entrega)
                          EXCLUSIVE-LOCK:
                    ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira - (ped-item.qt-pedida - ped-item.qt-atendida).
                END.

                RELEASE int-pv-canal.
        
                /*Soma no novo*/
                FOR FIRST int-pv-canal 
                    WHERE int-pv-canal.cod-canal = int-ped-venda2.int-1
                      AND int-pv-canal.it-codigo = ped-item.it-codigo
                      AND int-pv-canal.mes-meta  = MONTH(ped-item.dt-entrega)
                      AND int-pv-canal.ano-meta  = YEAR(ped-item.dt-entrega)
                          EXCLUSIVE-LOCK:
                    ASSIGN int-pv-canal.qt-carteira = int-pv-canal.qt-carteira + (ped-item.qt-pedida - ped-item.qt-atendida).
                END.

                RELEASE int-pv-canal.
            END.
            */
            
        END.
    END.
END.

RETURN "OK".
  
