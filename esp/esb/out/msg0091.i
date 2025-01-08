{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0091 NO-UNDO XML-NODE-NAME 'MSG0091'
   FIELD idm                         AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroPedido                LIKE ped-venda.nr-pedido
   FIELD Nome                        AS CHAR
   FIELD NumeroPedidoCliente         LIKE ped-venda.nr-pedcli
   FIELD NumeroPedidoRepresentante   LIKE ped-venda.nr-pedrep
   FIELD CodigoClienteCRM            AS CHAR
   FIELD TipoObjetoCliente           AS CHAR
   FIELD NomeAbreviadoCliente        LIKE ped-venda.Nome-abrev
   FIELD TabelaPreco                 AS CHAR /*informado pelo Jos‚ que nÆo precisa mais, passar 0*/
   FIELD TabelaPrecoEMS              AS CHAR
   FIELD TipoPreco                   LIKE ped-venda.tp-preco  
   FIELD Estabelecimento             LIKE ped-venda.cod-estabel
   FIELD CondicaoPagamento           LIKE ped-venda.cod-cond-pag
   FIELD TabelaFinanciamento         LIKE ped-venda.nr-tab-finan
   FIELD Representante               LIKE repres.cod-rep
   FIELD CodigoAssistente            LIKE ped-venda.tp-pedido
   FIELD CodigoSupervisorEMS         AS CHARACTER
   FIELD NaturezaOperacao            LIKE ped-venda.nat-operacao
   FIELD DataEmissao                 LIKE ped-venda.dt-emissao
   FIELD DataImplantacao             LIKE ped-venda.dt-implant
   FIELD UsuarioImplantacao          LIKE ped-venda.user-impl
   FIELD DataImplantacaoUsuario      LIKE ped-venda.dt-userimp
   FIELD DataEntrega                 LIKE ped-venda.dt-entrega
   FIELD DataEntregaSolicitada       LIKE ped-venda.dt-entorig
   FIELD DataMinimaFaturamento       LIKE ped-venda.dt-minfat
   FIELD DataLimiteFaturamento       LIKE ped-venda.dt-lim-fat
   FIELD DataCumprimento             AS DATE
   FIELD DataReativacao              LIKE ped-venda.dt-reativ
   FIELD DataReativacaoUsuario       LIKE ped-venda.dt-userrea
   FIELD DataNegociacao              LIKE int-ped-venda.dt-negociacao
   FIELD DiasNegociacao              LIKE int-ped-venda.dias-negociacao
   FIELD TipoPedido                  LIKE ped-venda.tp-pedido
   FIELD OrigemPedido                LIKE ped-venda.origem
   FIELD Prioridade                  LIKE ped-venda.cod-priori
   FIELD CPF                         LIKE ped-venda.cgc
   FIELD CNPJ                        LIKE ped-venda.cgc
   FIELD InscricaoEstadual           LIKE ped-venda.ins-estadual
   FIELD SituacaoPedido              AS CHAR
   FIELD Situacao                    LIKE ped-venda.cod-sit-ped
   FIELD PercentualDesconto1         LIKE ped-venda.perc-desco1 DECIMALS 2
   FIELD PercentualDesconto2         LIKE ped-venda.perc-desco2 DECIMALS 2
   FIELD CidadeCIF                   LIKE ped-venda.cidade-cif
   FIELD Portador                    LIKE ped-venda.cod-portador
   FIELD ModalidadeCobranca          LIKE ped-venda.modalidade
   FIELD Mensagem                    LIKE ped-venda.cod-mensagem
   FIELD Observacao                  LIKE ped-venda.observacoes
   FIELD CondicaoEspecial            LIKE ped-venda.cond-espec
   FIELD ObservacaoRedespacho        LIKE ped-venda.cond-redespa
   FIELD UsuarioAlteracao            LIKE ped-venda.user-alte
   FIELD DataAlteracao               LIKE ped-venda.dt-useralt
   FIELD UsuarioCancelamento         LIKE ped-venda.user-canc
   FIELD DescricaoCancelamento       LIKE ped-venda.desc-cancela
   FIELD DataCancelamento            LIKE ped-venda.dt-cancel
   FIELD DataCancelamentoUsuario     LIKE ped-venda.dt-usercan
   FIELD UsuarioReativacao           LIKE ped-venda.user-reat
   FIELD UsuarioSuspensao            LIKE ped-venda.user-suspen
   FIELD DescricaoSuspensao          LIKE ped-venda.desc-suspend FORMAT 'x(2000)'
   FIELD DataSuspensao               LIKE ped-venda.dt-suspensao
   FIELD IndicacaoAprovacao          LIKE ped-venda.ind-aprov
   FIELD AprovacaoForcada            AS CHAR
   FIELD UsuarioAprovacao            LIKE ped-venda.quem-aprovou
   FIELD DataAprovacao               LIKE ped-venda.dt-apr-cred
   FIELD DestinoMercadoria           LIKE ped-venda.cod-des-merc
   FIELD Transportadora              LIKE transporte.cod-transp
   FIELD NomeTransportadora          LIKE transporte.nome
   FIELD Rota                        LIKE ped-venda.cod-rota
   FIELD FaturamentoParcial          LIKE ped-venda.ind-fat-par
   FIELD Moeda                       AS CHAR
   FIELD ValorTotalLiquido           LIKE ped-venda.vl-liq-ped DECIMALS 4
   FIELD ValorTotalPedido            LIKE ped-venda.vl-tot-ped DECIMALS 4
   FIELD ValorTotalAberto            LIKE ped-venda.vl-liq-abe DECIMALS 4
   FIELD ValorMercadoriaAberto       LIKE ped-venda.vl-mer-abe DECIMALS 4
   FIELD IndiceFinanciamento         AS CHAR
   FIELD SituacaoAvaliacao           LIKE ped-venda.cod-sit-aval
   FIELD MotivoBloqueioCredito       LIKE ped-venda.desc-bloq-cr
   FIELD MotivoLiberacaoCredito      LIKE ped-venda.desc-forc-cr
   FIELD SituacaoAlocacao            LIKE ped-venda.cod-sit-pre
   FIELD ValorCreditoLiberado        LIKE ped-venda.vl-cred-lib DECIMALS 4
   FIELD ValorDesconto               LIKE ped-venda.vl-desconto DECIMALS 4
   FIELD PercentualDesconto          AS DEC DECIMALS 2
   FIELD PercentualDescontoICMS      LIKE ped-venda.per-des-icms DECIMALS 2
   FIELD CodigoEntrega               LIKE ped-venda.cod-entrega
   FIELD ValorFrete                  LIKE int-ped-venda.vl-frete DECIMALS 4
   FIELD CondicaoFrete               AS INT
   FIELD PedidoCompleto              LIKE ped-venda.completo
   FIELD CanalVenda                  LIKE ped-venda.cod-canal-venda
   FIELD ClienteTriangular           AS CHAR
   FIELD CodigoEntregaTriangular     LIKE ped-venda.cod-entrega-tri
   FIELD ListaPreco                  AS CHAR
   FIELD Descricao                   AS CHAR
   FIELD ValorTotalImpostos          AS DEC DECIMALS 4
   FIELD ValorTotalSemFrete          AS DEC DECIMALS 4
   FIELD ValorTotalDesconto          AS DEC DECIMALS 4
   FIELD CampanhaOrigem              AS CHAR
   FIELD PrecoBloqueado              AS LOG
   FIELD Classificacao               AS CHAR
   FIELD PedidoOriginal              AS CHAR
   FIELD TotalIPI                    AS DEC DECIMALS 4
   FIELD TotalSubstituicaoTributaria AS DEC DECIMALS 4
   FIELD Oportunidade                AS CHAR
   FIELD Proprietario                AS CHAR
   FIELD TipoProprietario            AS CHAR
   FIELD FormaPagamento              AS INT
   FIELD Cotacao                     AS CHAR
   FIELD CondicaoFreteEntrega        AS INT
   FIELD RetiraNoLocal               AS LOG
   FIELD AprovadorPedido             AS CHAR
   FIELD CodigoSolicitacaoBeneficio  AS CHAR 
   FIELD NomeUsuarioCriacao          AS CHAR 
   FIELD TipoUsuarioCriacao          AS INT .
   
   
DEFINE TEMP-TABLE EnderecoEntrega NO-UNDO XML-NODE-NAME 'EnderecoEntrega'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NomeEndereco                       LIKE emitente.nome-emit
   FIELD TipoEndereco                       AS INT /*1*/
   FIELD CaixaPostal                        AS CHAR
   FIELD CEP                                LIKE nota-fiscal.cep
   FIELD Logradouro                         AS CHAR
   FIELD Numero                             AS CHAR
   FIELD Complemento                        AS CHAR
   FIELD Bairro                             LIKE nota-fiscal.bairro    
   FIELD NomeCidade                         LIKE nota-fiscal.cidade    
   FIELD Cidade                             LIKE nota-fiscal.cidade    
   FIELD UF                                 LIKE nota-fiscal.estado    
   FIELD Estado                             LIKE nota-fiscal.estado    
   FIELD NomePais                           LIKE nota-fiscal.pais      
   FIELD Pais                               LIKE nota-fiscal.pais      
   FIELD NomeContato                        AS CHAR   
   FIELD Telefone                           LIKE emitente.telefone[1]  
   FIELD Fax                                LIKE emitente.telefax.

DEFINE TEMP-TABLE EnderecoEntregaIt NO-UNDO XML-NODE-NAME 'EnderecoEntrega'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NomeEndereco                       LIKE emitente.nome-emit
   FIELD TipoEndereco                       AS INT /*1*/
   FIELD CaixaPostal                        AS CHAR
   FIELD CEP                                LIKE nota-fiscal.cep
   FIELD Logradouro                         AS CHAR
   FIELD Numero                             AS CHAR
   FIELD Complemento                        AS CHAR
   FIELD Bairro                             LIKE nota-fiscal.bairro    
   FIELD NomeCidade                         LIKE nota-fiscal.cidade    
   FIELD Cidade                             LIKE nota-fiscal.cidade    
   FIELD UF                                 LIKE nota-fiscal.estado    
   FIELD Estado                             LIKE nota-fiscal.estado    
   FIELD NomePais                           LIKE nota-fiscal.pais      
   FIELD Pais                               LIKE nota-fiscal.pais      
   FIELD NomeContato                        AS CHAR   
   FIELD Telefone                           LIKE emitente.telefone[1]  
   FIELD Fax                                LIKE emitente.telefax.

DEFINE TEMP-TABLE EnderecoCobranca NO-UNDO XML-NODE-NAME 'EnderecoCobranca'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NomeEndereco                       LIKE emitente.nome-emit
   FIELD TipoEndereco                       AS INT /*1*/
   FIELD CaixaPostal                        AS CHAR
   FIELD CEP                                LIKE nota-fiscal.cep
   FIELD Logradouro                         AS CHAR
   FIELD Numero                             AS CHAR 
   FIELD Complemento                        AS CHAR
   FIELD Bairro                             LIKE nota-fiscal.bairro    
   FIELD NomeCidade                         LIKE nota-fiscal.cidade    
   FIELD Cidade                             LIKE nota-fiscal.cidade    
   FIELD UF                                 LIKE nota-fiscal.estado    
   FIELD Estado                             LIKE nota-fiscal.estado    
   FIELD NomePais                           LIKE nota-fiscal.pais      
   FIELD Pais                               LIKE nota-fiscal.pais      
   FIELD NomeContato                        AS CHAR   
   FIELD Telefone                           LIKE emitente.telefone[1]  
   FIELD Fax                                LIKE emitente.telefax.

DEFINE TEMP-TABLE ItensPedidos NO-UNDO XML-NODE-NAME 'PedidosItens'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE msg0091-1 NO-UNDO XML-NODE-NAME 'PedidoItem'
    FIELD idm                          AS INT XML-NODE-TYPE 'hidden'
    FIELD ChaveIntegracao              AS CHAR
    FIELD NumeroPedido                 LIKE ped-venda.nr-pedido
    FIELD NumeroPedidoCliente          LIKE ped-item.nr-pedcli
    FIELD Sequencia                    LIKE ped-item.nr-sequencia
    FIELD Produto                      LIKE ped-item.it-codigo
    FIELD DescricaoItemPedido          LIKE item.desc-item
    FIELD UnidadeMedida                LIKE item.un
    FIELD NaturezaOperacao             LIKE ped-item.nat-operacao
    FIELD DataEntregaSolicitada        LIKE ped-item.dt-entorig
    FIELD DataEntrega                  LIKE ped-item.dt-entrega
    FIELD DataImplantacao              LIKE ped-venda.dt-implant
    FIELD QuantidadePedida             LIKE ped-item.qt-pedida DECIMALS 5
    FIELD QuantidadeEntregue           LIKE ped-item.qt-atendida DECIMALS 5
    FIELD QuantidadePendente           LIKE ped-item.qt-pendente DECIMALS 5
    FIELD QuantidadeDevolvida          LIKE ped-item.qt-devolvida DECIMALS 2
    FIELD QuantidadeCancelada          LIKE ped-item.qt-pedida  DECIMALS 5
    FIELD DataDevolucao                LIKE ped-item.dt-devolucao
    FIELD DataDevolucaoUsuario         LIKE ped-item.dt-devolucao
    FIELD DescricaoDevolucao           LIKE ped-item.desc-devol
    FIELD UsuarioDevolucao             LIKE ped-item.user-devol
    FIELD ValorTabela                  LIKE ped-item.vl-pretab DECIMALS 4
    FIELD ValorOriginal                LIKE ped-item.vl-preori DECIMALS 4
    FIELD PrecoNegociado               LIKE ped-item.vl-preori DECIMALS 4
    FIELD PrecoMinimo                  LIKE ped-item.per-minfat DECIMALS 4
    FIELD SituacaoItem                 LIKE ped-item.cod-sit-item
    FIELD UsuarioImplantacao           LIKE ped-item.user-impl
    FIELD UsuarioAlteracao             LIKE ped-item.user-alte
    FIELD DataAlteracao                LIKE ped-item.dt-useralt
    FIELD UsuarioCancelamento          LIKE ped-item.user-canc
    FIELD DataCancelamentoSequencia    LIKE ped-item.dt-canseq
    FIELD DescricaoCancelamento        LIKE ped-item.desc-cancela
    FIELD DataCancelamentoUsuario      LIKE ped-item.dt-canseq
    FIELD UsuarioReativacao            LIKE ped-item.user-reat
    FIELD DataReativacao               LIKE ped-item.dt-reativ
    FIELD DataReativacaoUsuario        LIKE ped-item.dt-reativ
    FIELD UsuarioSuspensao             LIKE ped-item.user-susp
    FIELD DataSuspensao                LIKE ped-item.dt-suspensao
    FIELD DataSuspensaoUsuario         LIKE ped-item.dt-suspensao
    FIELD AliquotaIPI                  LIKE ped-item.aliquota-ipi DECIMALS 2
    FIELD RetemICMSFonte               LIKE ped-item.ind-icm-ret
    FIELD PercentualDescontoICMS       AS DEC
    FIELD ValorLiquido                 LIKE ped-item.vl-liq-it DECIMALS 4
    FIELD ValorLiquidoAberto           LIKE ped-item.vl-liq-abe DECIMALS 4
    FIELD ValorMercadoriaAberto        LIKE ped-item.vl-liq-abe DECIMALS 4
    FIELD ValorTotal                   LIKE ped-item.vl-tot-it DECIMALS 4
    FIELD TipoPreco                    LIKE ped-item.tp-preco
    FIELD Observacao                   LIKE ped-item.observacao
    FIELD QuantidadeAlocada            LIKE ped-item.qt-alocada DECIMALS 2
    FIELD SituacaoAlocacao             LIKE ped-item.cod-sit-pre
    FIELD PercentualMinimoFaturamento  AS DEC DECIMALS 2 
    FIELD DataMaximaFaturamento        LIKE ped-item.dt-max-fat
    FIELD DataMinimaFaturamento        LIKE ped-item.dt-min-fat
    FIELD QuantidadeAlocadaLogica      LIKE ped-item.qt-log-aloca DECIMALS 2
    FIELD PermiteSubstituirPreco       AS LOG
    FIELD FaturaQuantidadeFamilia      LIKE ped-item.ind-fat-qtfam
    FIELD TaxaCambio                   AS DEC
    FIELD DescontoManual               LIKE ped-item.val-desconto-inform DECIMALS 2
    FIELD CondicaoFrete                AS INT
    FIELD RetiraNoLocal                AS LOG
    FIELD ValorTotalImposto            AS DEC DECIMALS 4
    FIELD ValorSubstituicaoTributaria  AS DEC DECIMALS 4
    FIELD ValorIPI                     LIKE ped-item.val-ipi DECIMALS 4
    FIELD ProdutoForaCatalogo          AS LOG
    FIELD DescricaoProdutoForaCatalogo AS CHAR
    FIELD Moeda                        AS CHAR
    FIELD UnidadeNegocio               LIKE ped-item.cod-unid-negoc
    FIELD Acao                         AS CHAR
    FIELD Representante                LIKE repres.cod-rep
    FIELD NomeAbreviadoCliente         LIKE ped-venda.nome-abrev
    FIELD ValorTotalProduto            LIKE ped-item.vl-tot-it DECIMALS 4
    FIELD CalcularRebate               AS LOGICAL
    FIELD PercentualDescontoVerde      AS DEC DECIMALS 4
    FIELD PercentualDescontoTopMilhao  AS DEC DECIMALS 4
    FIELD PercentualRebateAntecipado   AS DEC DECIMALS 4
    .

DEFINE TEMP-TABLE msg0091r NO-UNDO XML-NODE-NAME 'MSG0091R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo     AS CHAR
    FIELD de-quantidade AS DEC
    FIELD TipoPortfolio AS INTEGER
    FIELD CodigoUnidadeNegocio AS CHAR
    FIELD CodigoFamiliaComercial AS CHAR
    FIELD CodigoEstabelecimento  AS CHAR.

DEFINE TEMP-TABLE ProdutoItemR NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD PrecoBase                AS DEC
    FIELD ValorProduto             AS DEC
    FIELD NomePoliticaComercial    AS CHAR
    FIELD TemCache                 AS LOGICAL
    FIELD DataValidade             AS DATE
    FIELD QuantidadeMaxima         AS DEC
    FIELD RebateAntecipado         AS LOGICAL
    FIELD CalcularRebate             AS LOGICAL
    FIELD PrecoAlterado              AS LOGICAL
    FIELD ValorComDesconto           AS DEC
    FIELD PercentualDescontoVerde     AS DEC
    FIELD PercentualDescontoTopMilhao AS DEC
    FIELD PercentualRebateAntecipado  AS DEC.

