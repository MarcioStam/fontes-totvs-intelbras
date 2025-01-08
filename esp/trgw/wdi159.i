FUNCTION fnAlteraPrioridadeFaturamentoParcial RETURNS INTEGER
  ( INPUT p-nr-pedido   AS INTEGER,
    INPUT p-cod-sit-ped AS INTEGER,
    INPUT p-cod-priori  AS INTEGER)  FORWARD.

DEF BUFFER b-int-ped-venda-PRIORI FOR int-ped-venda.

FUNCTION fnAlteraPrioridadeFaturamentoParcial RETURNS INTEGER
  ( INPUT p-nr-pedido   AS INTEGER,
    INPUT p-cod-sit-ped AS INTEGER,
    INPUT p-cod-priori  AS INTEGER) :
    /*------------------------------------------------------------------------------------
      Purpose:  Retornar a prioridade do pedido com base no atendimento parcial
    -------------------------------------------------------------------------------------*/
                                                                             
    IF  p-cod-sit-ped <> 2 AND p-cod-sit-ped <> 3 THEN /*n∆o Ç parcial nem total*/
        RETURN p-cod-priori.

    FIND b-int-ped-venda-PRIORI NO-LOCK
        WHERE b-int-ped-venda-PRIORI.nr-pedido = p-nr-pedido NO-ERROR.

    IF  NOT AVAIL b-int-ped-venda-PRIORI THEN
        RETURN p-cod-priori.

     /* TOTAL s¢ volta a prioridade original para pedidos programados */
     IF  p-cod-sit-ped = 3 THEN 
         IF  b-int-ped-venda-PRIORI.cod-priori-orig = 02 /*Programados*/ THEN
             RETURN b-int-ped-venda-PRIORI.cod-priori-orig.
         ELSE
             RETURN p-cod-priori.
    
    /* Parcial*/
    IF  p-cod-sit-ped = 2 THEN DO:
        /* Testa se a prioridade original Ç 02, 03, ou 04. Nestes casos volta a prioridade */
        IF  b-int-ped-venda-PRIORI.cod-priori-orig = 02 
        OR  b-int-ped-venda-PRIORI.cod-priori-orig = 03
        OR  b-int-ped-venda-PRIORI.cod-priori-orig = 04
        OR  b-int-ped-venda-PRIORI.cod-priori-orig = 05
        OR  b-int-ped-venda-PRIORI.cod-priori-orig = 06 THEN
            RETURN b-int-ped-venda-PRIORI.cod-priori-orig.
        ELSE
            RETURN p-cod-priori.
     END.
END FUNCTION.
