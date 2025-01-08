define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character
   field dt-inicial  as date
   field dt-final    as date.


DEF TEMP-TABLE ttHistoricoEventos NO-UNDO
    FIELD CD_Sequencia_Historico LIKE int-historico-evento.num-seq-historico 
    FIELD CD_Evento_Monitorado   LIKE int-historico-evento.cod-evento
    FIELD CD_Estabelecimento     LIKE int-historico-evento.cod-estabel       
    FIELD CD_Emitente            LIKE int-historico-evento.cod-emitente
    FIELD CD_Pedido_Cliente      LIKE int-historico-evento.nr-pedcli
    FIELD CD_Sequencia           LIKE int-historico-evento.nr-sequencia
    FIELD CD_Item                LIKE int-historico-evento.it-codigo       
    FIELD CD_Situacao_Pedido     LIKE int-historico-evento.cod-sit-ped
    FIELD CD_Situacao_Item       LIKE int-historico-evento.cod-sit-item        
    FIELD CD_Usuario             LIKE int-historico-evento.cod-usuario        
    FIELD CD_Situacao_Preco_Min  LIKE int-historico-evento.ind-status-preco      
    FIELD CD_Situacao_Credito    LIKE int-historico-evento.cod-sit-aval     
    FIELD CD_Motivo_Cancelamento LIKE int-historico-evento.cod-motivo-cancela  
    FIELD DT_Movimento_Historico LIKE int-historico-evento.dat-historico
    FIELD NM_Qtd_Alocada_Pedido LIKE int-historico-evento.qtd-alocada-pedido
    INDEX id_ped_cli IS PRIMARY UNIQUE CD_Sequencia_Historico.

