define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character
   field dt-inicial  as date
   field dt-final    as date.

DEF TEMP-TABLE ttCicloPedidoVenda NO-UNDO
    FIELD CD_Estabelecimento    LIKE ped-venda.cod-estabel
    FIELD CD_Emitente           LIKE ped-venda.cod-emitente
    FIELD CD_Pedido_Cliente     LIKE ped-venda.nr-pedcli
    FIELD CD_Situacao_Pedido    LIKE ped-venda.cod-sit-ped
    FIELD CD_Sequencia          LIKE ped-item.nr-sequencia
    FIELD CD_Item               LIKE ped-item.it-codigo
    FIELD CD_Situacao_Item      LIKE ped-item.cod-sit-item
    FIELD CD_Representante      LIKE repres.cod-rep
    FIELD CD_Pais               LIKE ped-venda.pais
    FIELD CD_Estado             LIKE ped-venda.estado
    FIELD CD_Cidade             LIKE ped-venda.cidade
    FIELD CD_Transportador      LIKE transporte.cod-transp
    FIELD CD_Serie              LIKE nota-fiscal.serie
    FIELD CD_Nota_Fiscal        LIKE nota-fiscal.nr-nota-fis
    FIELD CD_Sequencia_Nota     LIKE it-nota-fisc.nr-seq-fat
    FIELD CD_Natureza_Operacao  LIKE ped-venda.nat-operacao
    FIELD CD_Atendente          LIKE ped-venda.tp-pedido
    FIELD CD_Transportador_Nota LIKE transporte.cod-transp
    FIELD DT_Emissao            LIKE ped-venda.dt-emissao
    FIELD DT_Implantacao        LIKE ped-venda.dt-implant  
    FIELD DT_Aprova_Credito     LIKE ped-venda.dt-apr-cred 
    FIELD DT_Cancela_Pedido     LIKE ped-venda.dt-cancela  
    FIELD DT_Devolucao          LIKE ped-venda.dt-devolucao
    FIELD DT_Reativacao         LIKE ped-venda.dt-reativ   
    FIELD DT_Suspensao          LIKE ped-venda.dt-suspensao
    FIELD DT_Entrega_Prev       LIKE ped-venda.dt-entorig  
    FIELD DT_Cancela_Nota       LIKE nota-fiscal.dt-cancela
    FIELD DT_Faturamento        LIKE nota-fiscal.dt-emis-nota
    FIELD DT_Saida_Nota         LIKE nota-fiscal.dt-saida
    FIELD DT_Aprov_Abaixo_Preco LIKE int-ped-item.data-aprovacao
    FIELD DT_Cancela_Item       LIKE ped-item.dt-canseq
    FIELD NM_VL_Total_Item      LIKE ped-item.vl-tot-it
    FIELD NM_VL_Devolucao       LIKE devol-cli.vl-devol
    INDEX id_ped_cli IS PRIMARY UNIQUE CD_Emitente CD_Pedido_Cliente CD_Sequencia CD_Item.


