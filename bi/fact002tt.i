define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character
   field dt-inicial  as date
   field dt-final    as date.

define temp-table ttFactDevolucao no-undo
   field CD_Estabelecimento   like devol-cli.cod-estabel
   field CD_Serie             like devol-cli.serie
   field CD_Nota_Fiscal       like devol-cli.nr-nota-fis
   field CD_Sequencia         like devol-cli.nr-sequencia
   field CD_Item              like devol-cli.it-codigo
   field CD_Unidade_Negocio   like unid-neg-fat.cod_unid_negoc
   field CD_Emitente          like devol-cli.cod-emitente
   field CD_Representante     like nota-fiscal.cod-rep
   field CD_Natureza_Operacao like devol-cli.nat-operacao
   field CD_Pais              like nota-fiscal.pais
   field CD_Estado            like nota-fiscal.estado
   field CD_Cidade            like nota-fiscal.cidade
   field CD_Atendente         like ped-venda.tp-pedido
   field CD_Serie_Devolucao   like devol-cli.serie-docto
   field CD_Nro_Devolucao     like devol-cli.nro-docto
   field CD_Seq_Devolucao     like devol-cli.sequencia
   field CD_Unidade_Comercial as integer
   field CD_Canal             as integer
   field DT_Devolucao         like devol-cli.dt-devol
   field CD_Deposito          like item-doc-est.cod-depos
   field NM_Quantidade        as decimal
   field NM_Vl_Unitario       as decimal
   field NM_Vl_Liquido        as decimal
   field NM_Vl_Total          as decimal
   field NM_Vl_Taxa_Cambial   as decimal
   field NM_Vl_Acordo         as decimal
   field CD_Motivo_Dev        as integer  
   index idx_pri is primary unique CD_Estabelecimento CD_Serie CD_Nota_Fiscal CD_Sequencia CD_Item CD_Unidade_Negocio
                                   CD_Serie_Devolucao CD_Nro_Devolucao CD_Emitente CD_Natureza_Operacao CD_Seq_Devolucao.
