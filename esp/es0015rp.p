{esp/es0015.i}

DEF input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.


DEF VAR l-troca AS LOG.

FOR EACH ped-venda 
    WHERE ped-venda.cod-sit-ped <= 2
    AND   ped-venda.cod-priori = 10 
    BY nr-pedcli:
   
    IF CAN-FIND(FIRST ped-item OF ped-venda
        WHERE ped-item.qt-log-aloc <> 0) THEN 
       NEXT.

    ASSIGN l-troca = NO.
    
    FOR EACH ped-item OF ped-venda NO-LOCK
        WHERE ped-item.cod-sit-item <= 2:

        IF ped-item.qt-alocada <> 0 THEN
           IF ped-item.qt-alocada <> ped-item.qt-atendida THEN DO:
               ASSIGN l-troca = NO.
               LEAVE.
           END.
        
        ASSIGN l-troca = YES.
    END.
    
    IF l-troca THEN DO:
       ASSIGN ped-venda.cod-priori = 99. 
       IF ped-venda.tp-pedido = "99" THEN 
          ASSIGN ped-venda.tp-pedido = "94".
   END.
END.    
    
    
    /*

DEF VAR l-troca AS LOG.

FOR EACH ped-venda 
    WHERE ped-venda.cod-sit-ped <= 2
    AND   ped-venda.cod-priori = 10 BY nr-pedcli:
   
    IF CAN-FIND(FIRST ped-item OF ped-venda
        WHERE ped-item.qt-log-aloc <> 0) THEN 
       NEXT.

    ASSIGN l-troca = YES.
    
    FOR EACH ped-item OF ped-venda NO-LOCK
        WHERE ped-item.cod-sit-item <= 2:
        FIND LAST it-pre-fat NO-LOCK
            WHERE it-pre-fat.nr-pedcli    = ped-item.nr-pedcli
            AND   it-pre-fat.nome-abrev   = ped-item.nome-abrev
            AND   it-pre-fat.it-codigo    = ped-item.it-codigo
            AND   it-pre-fat.nr-sequencia = ped-item.nr-sequencia 
            AND   it-pre-fat.cdd-embarq > 0 NO-ERROR.
        
        IF NOT AVAIL it-pre-fat THEN NEXT.
        
        FIND FIRST it-nota-fisc NO-LOCK WHERE
            it-nota-fisc.cdd-embarq = it-pre-fat.cdd-embarq AND
            it-nota-fisc.it-codigo   = ped-item.it-codigo NO-ERROR.

        IF NOT AVAIL it-nota-fisc THEN DO:
           ASSIGN l-troca = NO.
           LEAVE.
        END.
    END.
    IF l-troca THEN
       ASSIGN ped-venda.cod-priori = 99. 
END.
*/
