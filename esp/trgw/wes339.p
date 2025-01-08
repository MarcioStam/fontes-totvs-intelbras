/********************************************************************************
 ** UPC........: wes339.p - WRITE int-ped-item    
 ** Data.......: Junho / 2013
 ** Objetivo...: Projeto Moderniza‡Æo Vendas - Controle hist¢rico de eventos para monitorar prazos de entrega dos pedidos
 ********************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF int-ped-item.

{utp/ut-glob.i}

DEFINE VARIABLE i-sequencia   AS INTEGER   NO-UNDO.

/* Projeto Moderniza‡Æo Vendas - Controle hist¢rico de eventos para monitorar prazos de entrega dos pedidos */
IF  int-ped-item.ind-status-preco > 0
THEN DO:
    FIND int-evento-monitorado NO-LOCK
        WHERE int-evento-monitorado.cod-evento = 2 /* Aprova‡Æo/Rejei‡Æo pedido abaixo minimo */
          AND int-evento-monitorado.log-ativo  = YES NO-ERROR.
    
    IF AVAIL int-evento-monitorado
    THEN DO:
        FIND FIRST ped-item OF int-ped-item NO-LOCK NO-ERROR.
    
        IF  AVAIL ped-item 
        THEN DO:
            FIND ped-venda OF ped-item NO-LOCK NO-ERROR.
    
            IF  AVAIL ped-venda 
            THEN DO:
                ASSIGN i-sequencia = 1.
                FIND LAST int-historico-evento NO-LOCK NO-ERROR.
                IF  AVAIL int-historico-evento
                THEN
                    ASSIGN i-sequencia = int-historico-evento.num-seq-historico + 1.

                 RELEASE int-historico-evento.

                 FIND FIRST int-historico-evento NO-LOCK
                      WHERE int-historico-evento.num-seq-historico = i-sequencia NO-ERROR.
                 IF NOT AVAIL int-historico-evento THEN DO:
                    CREATE int-historico-evento.
                    ASSIGN int-historico-evento.num-seq-historico  = i-sequencia
                           int-historico-evento.cod-emitente       = ped-venda.cod-emitente
                           int-historico-evento.nr-pedcli          = ped-venda.nr-pedcli
                           int-historico-evento.cod-estabel        = ped-venda.cod-estabel
                           int-historico-evento.cod-sit-item       = ped-item.cod-sit-item
                           int-historico-evento.it-codigo          = ped-item.it-codigo
                           int-historico-evento.nr-sequencia       = ped-item.nr-sequencia
                           int-historico-evento.qtd-alocada-pedido = ped-item.qt-log-aloca
                           int-historico-evento.qtd-pedida         = ped-item.qt-pedida
                           int-historico-evento.ind-status-preco   = int-ped-item.ind-status-preco
                           int-historico-evento.cod-evento         = int-evento-monitorado.cod-evento
                           int-historico-evento.cod-usuario        = c-seg-usuario
                           int-historico-evento.dat-historico      = NOW.
                 END.
                RELEASE int-historico-evento.
            END. /* IF  AVAIL ped-venda */
        END. /* IF  AVAIL ped-item */
    END. /* IF AVAIL int-evento-monitorado */
END. /* IF  int-ped-item.ind-status-preco > 0 */



RETURN "OK".

