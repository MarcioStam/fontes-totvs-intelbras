define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character
   field dt-inicial  as date
   field dt-final    as date.

define temp-table ttFactEntrada no-undo
    field CD_Documento                      like docum-est.nro-docto
    field CD_Serie                          like docum-est.serie-docto
    field CD_Natureza_Operacao              like docum-est.nat-operacao
    field CD_Emitente                       like docum-est.cod-emitente
    field CD_Estabelecimento                like docum-est.cod-estabel
    field CD_Sequencia                      like item-doc-est.sequencia
    field CD_Item                           like item-doc-est.it-codigo
    field CD_Conta                          like item-doc-est.ct-codigo    
    field CD_Centro_Custo                   like item-doc-est.sc-codigo
    field CD_Deposito                       like item-doc-est.cod-depos
    field CD_Unidade_Negocio                like unid-neg-fam-com.cod_unid_negoc
    field CD_Unidade_Negocio_Nota           like unid-neg-fam-com.cod_unid_negoc
    field CD_Embarque                       like embarque-imp.embarque
    field CD_Declaracao_Importacao          like embarque-imp.declaracao-imp
    field CD_Pedido_Compra                  like ordem-compra.num-pedido
    field CD_Ordem_Compra                   like ordem-compra.numero-ordem
    field CD_Ordem_Producao                 like item-doc-est.nr-ord-prod
    field CD_Moeda                          like ordem-compra.mo-codigo
    field CD_Pais                           like emitente.pais
    field CD_Estado                         like emitente.estado
    field CD_Cidade                         like emitente.cidade
    field CD_Modal                          like embarque-imp.cod-via-transp
    field CD_Motivo_Dev                     as integer  
    field DT_Transacao                      like docum-est.dt-trans
    field DT_Emissao                        like docum-est.dt-emissao
    field DT_Declaracao_Importacao          like embarque-imp.data-di
    field DT_Embarque                       like historico-embarque.dt-efetiva
    field NM_Quantidade                     like item-doc-est.quantidade     init 0
    field NM_Preco_Unitario                 like item-doc-est.preco-unit[1]  init 0
    field NM_Vl_Mercadoria_FOB              like item-doc-est.preco-total[1] init 0
    field NM_Vl_Mercadoria_CIF              like movto-estoq.valor-mat-m[1]  init 0
    field NM_Vl_Frete                       like docum-est.valor-frete       init 0
    field NM_Vl_Seguro                      like docum-est.valor-seguro      init 0
    field NM_Vl_Handling                      as dec                         init 0
    field NM_Vl_Ipi                         like item-doc-est.valor-ipi[1]   init 0
    field NM_Vl_Pis                           as dec                         init 0
    field NM_Vl_Cofins                        as dec                         init 0
    field NM_Vl_Icms                        like item-doc-est.valor-icm[1]   init 0
    field NM_Vl_Icms_Compl                  like item-doc-est.icm-complem[1] init 0
    field NM_Vl_Importacao                    as dec                         init 0
    field NM_Outras_Despesas                  as dec                         init 0
    field NM_Despesa_Total                    as dec                         init 0
    field NM_Preco_Total_Item               like docum-est.tot-valor         init 0
    field NM_Preco_Declaracao_Importacao    like item-doc-est.preco-unit[1]  init 0
    field NM_Cotacao_Declaracao_Importacao    as dec decimals 4              init 0
    field NM_Preco_Unit_Ordem_Compra        like ordem-compra.preco-unit     init 0
    field NM_Cotacao_Ordem_Compra             as dec decimals 4              init 0
    field NM_Vl_Nota_Complementar             as dec                         init 0
    field NM_Fator_Internacao                 as dec decimals 4              init 0
    index idx_pri is primary unique CD_Serie CD_Documento CD_Emitente CD_Natureza_Operacao CD_Sequencia.

DEF TEMP-TABLE tt-docum-est-fora-faixa NO-UNDO
    FIELD row-docum-est AS ROWID
    INDEX id-docum-est
            row-docum-est.

DEF BUFFER b-docum-est          FOR docum-est.
DEF BUFFER b-historico-embarque FOR historico-embarque.
DEF BUFFER b-item-doc-est       FOR item-doc-est.
