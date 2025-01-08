{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0093 NO-UNDO XML-NODE-NAME 'MSG0093'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD nat-operacao           AS CHAR XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedido           AS CHAR
   FIELD NumeroPedidoCliente    AS CHAR
   FIELD PedidoOriginal         AS CHAR
   FIELD Representante          AS INT
   FIELD CodigoClienteCRM       AS CHAR
   FIELD TipoObjetoCliente      AS CHAR
   FIELD Atendente              AS INT
   FIELD CodigoSupervisorEMS    AS CHARACTER
   FIELD Estabelecimento        AS CHAR
   FIELD CondicaoPagamento      AS INT
   FIELD CondicaoEspecial       AS CHAR
   FIELD Observacao             AS CHAR
   FIELD FaturamentoParcial     AS LOG
   FIELD Vendor                 AS LOG
   FIELD DiasBaseVendor         AS INT
   FIELD TaxaClienteVendor      AS DEC
   FIELD DataEmissao            AS DATE
   FIELD DataEntrega            AS DATE
   FIELD DataNegociacao         AS DATE
   FIELD DiasNegociacao         AS INT
   FIELD Situacao               AS INT
   FIELD NomeUsuarioCriacao     AS CHAR
   FIELD TipoUsuarioCriacao     AS INT
   FIELD origem                 AS INT
   FIELD cod-unid-neg           AS CHAR
   FIELD tp-beneficio           AS INT
   FIELD canal-venda            AS INT 
   FIELD PedidoProgramado       AS LOG  
   FIELD ValorServicoInstalacao AS DEC
   FIELD TipoNaturezaOperacao   AS INT
   FIELD TabelaPrecoEMS         AS CHAR
   FIELD IdentificacaoCartao    AS CHAR
   FIELD OrigemPedido           AS CHAR
   FIELD NumeroReferencia       AS CHAR
   FIELD tid                    AS CHAR
   FIELD nomeItemPai            AS CHAR
   FIELD ncmItemPai             AS CHAR
   FIELD dadosSolar             AS CHAR.
   
DEFINE TEMP-TABLE parcelas NO-UNDO XML-NODE-NAME 'Parcelas'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE parcela NO-UNDO XML-NODE-NAME 'Parcela'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD DataVencimento LIKE cond-ped.data-pagto 
    FIELD ValorParcela   LIKE cond-ped.vl-pagto  
    FIELD ObservacaoVencimento LIKE cond-ped.observacoes .

DEFINE TEMP-TABLE itens NO-UNDO XML-NODE-NAME 'PedidoItens'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE item-pedido NO-UNDO XML-NODE-NAME 'PedidoItem'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD acao                    AS CHAR
   FIELD ChaveIntegracao         AS CHAR
   FIELD Produto                 AS CHAR
   FIELD Sequencia               AS INT
   FIELD QuantidadePedida        AS INT
   FIELD PrecoOriginal           AS DEC
   FIELD CalcularRebate          AS LOGICAL
   FIELD PercentualDescontoVerde     AS DEC
   FIELD PercentualDescontoTopMilhao AS DEC
   FIELD PercentualRebateAntecipado  AS DEC
   .

DEFINE TEMP-TABLE itempai NO-UNDO XML-NODE-NAME 'ItemPai'
    FIELD idm              AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoProduto    AS CHAR
    FIELD QuantidadePedida AS INT.

DEFINE TEMP-TABLE msg0093r NO-UNDO XML-NODE-NAME 'MSG0093R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE pedidor NO-UNDO XML-NODE-NAME 'Pedido'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroPedido                AS CHAR
    FIELD Representante               AS INT
    FIELD CodigoClienteCRM            AS CHAR
    FIELD TipoObjetoCliente           AS CHAR
    FIELD Atendente                   AS INT
    FIELD CodigoSupervisorEMS         AS CHAR
    FIELD Estabelecimento             AS CHAR
    FIELD CondicaoPagamento           AS INT
    FIELD CondicaoEspecial            AS CHAR
    FIELD Observacao                  AS CHAR
    FIELD FaturamentoParcial          AS LOG
    FIELD Vendor                      AS LOG
    FIELD DiasBaseVendor              AS INT
    FIELD TaxaClienteVendor           AS DEC
    FIELD DataEmissao                 AS DATE
    FIELD DataEntrega                 AS DATE
    FIELD DataNegociacao              AS DATE
    FIELD DiasNegociacao              AS INT
    FIELD TotalIPI                    AS DEC
    FIELD TotalSubstituicaoTributaria AS DEC
    FIELD ValorTotalPedido            AS DEC
    FIELD Situacao                    AS INT.
    

DEFINE TEMP-TABLE itensr NO-UNDO XML-NODE-NAME 'Itens'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE item-pedidor NO-UNDO XML-NODE-NAME 'Item'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD ChaveIntegracao             AS CHAR
   FIELD Produto                     AS CHAR
   FIELD Sequencia                   AS INT
   FIELD QuantidadePedida            AS INT
   FIELD PrecoOriginal               AS DEC
   FIELD ValorLiquido                AS DEC
   FIELD ValorLiquidoAberto          AS DEC
   FIELD ValorSubstituicaoTributaria AS DEC
   FIELD ValorIPI                    AS DEC
   FIELD AliquotaIPI                 AS DEC
   FIELD ValorICMS                   AS DEC
   FIELD AliquotaICMS                AS DEC
   FIELD ValorTotal                  AS DEC
   FIELD CalcularRebate              AS LOGICAL
   FIELD PercentualDescontoVerde       AS DEC
   //FIELD PercentualDescontoTopMilhao   AS DEC
   //FIELD PercentualRebateAntecipado    AS DEC
    .



   
