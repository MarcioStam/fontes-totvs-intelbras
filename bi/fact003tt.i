define temp-table tt-param no-undo
   field usuario  as character
   field senha    as character.

define temp-table ttCarteiraVendas no-undo
   field CD_Estabelecimento      like ped-venda.cod-estabel
   field CD_Emitente             like ped-venda.cod-emitente
   field CD_Pedido_Cliente       like ped-venda.nr-pedcli
   field CD_Sequencia            like ped-item.nr-sequencia
   field CD_Item                 like ped-item.it-codigo
   field CD_Unidade_Negocio      like unid-neg-ped.cod_unid_negoc
   field DT_Entrega              like ped-item.dt-entrega
   field CD_Representante        like repres.cod-rep
   field CD_Natureza_Operacao    like ped-item.nat-operacao
   field CD_Pais                 like ped-venda.pais
   field CD_Estado               like ped-venda.estado
   field CD_Cidade               like ped-venda.cidade
   field CD_Condicao_Pagamento   like ped-venda.cod-cond-pag
   field CD_Transportador        like transporte.cod-transp
   field CD_Frete                as character
   field CD_Atendente            like ped-venda.tp-pedido
   field CD_Situacao_Avaliacao   like ped-venda.cod-sit-aval
   field CD_Canal                as integer
   field CD_Prioridade           as integer
   field DT_Carteira             as date
   field DT_Implant_Ped          as date
   field NM_Qtde_Saldo           as decimal
   field NM_Vl_Unitario          as decimal
   field NM_Vl_Liquido           as decimal
   field NM_Vl_Total             as decimal
   field NM_Vl_Pendente          as decimal
   field NM_Vl_Acordo            as decimal
   field NM_Qtde_Saldo_Aloc      as decimal
   field TX_Motivo_Reprov        as character 
   FIELD NM_Vl_Taxa_Cambial      AS DECIMAL DECIMALS 4
   FIELD DT_Entrega_Original     AS DATE
    index idx_pri is primary unique CD_Estabelecimento CD_Emitente CD_Pedido_Cliente CD_Sequencia CD_Item DT_Entrega CD_Unidade_Negocio.
