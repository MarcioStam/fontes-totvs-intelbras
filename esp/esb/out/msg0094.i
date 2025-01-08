{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0094 NO-UNDO XML-NODE-NAME 'MSG0094'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD ChaveIntegracao                    AS CHAR
   FIELD NumeroNotaFiscal                   LIKE nota-fiscal.nr-nota-fis    
   FIELD Nome                               AS CHAR
   FIELD NumeroSerie                        LIKE nota-fiscal.serie        
   FIELD CodigoClienteCRM                   AS CHAR
   FIELD TipoObjetoCliente                  AS CHAR
   FIELD NumeroPedido                       LIKE ped-venda.nr-pedido        
   FIELD NumeroPedidoCliente                LIKE nota-fiscal.nr-pedcli      
   FIELD Descricao                          AS CHAR
   FIELD Estabelecimento                    LIKE nota-fiscal.cod-estabel    
   FIELD CondicaoPagamento                  LIKE nota-fiscal.cod-cond-pag   
   FIELD NomeAbreviadoCliente               LIKE nota-fiscal.nome-ab-cli    
   FIELD NaturezaOperacao                   LIKE nota-fiscal.nat-operacao   
   FIELD Moeda                              LIKE nota-fiscal.mo-codigo      
   FIELD SituacaoNota                       AS INT
   FIELD SituacaoEntrega                    AS INT
   FIELD DataEmissao                        LIKE nota-fiscal.dt-emis-nota
   FIELD DataSaida                          LIKE nota-fiscal.dt-saida
   FIELD DataEntrega                        AS DATE 
   FIELD DataConfirmacao                    LIKE nota-fiscal.dt-confirma
   FIELD DataCancelamento                   LIKE nota-fiscal.dt-cancel
   FIELD DataConclusao                      AS DATE
   FIELD ValorFrete                         AS DEC 
   FIELD PesoLiquido                        AS DEC 
   FIELD PesoBruto                          AS DEC 
   FIELD Observacao                         LIKE nota-fiscal.observ-nota   
   FIELD Volume                             AS CHAR
   FIELD ValorBaseICMS                      AS DEC 
   FIELD ValorICMS                          AS DEC 
   FIELD ValorIPI                           AS DEC 
   FIELD ValorBaseSubstituicaoTributaria    AS DEC 
   FIELD ValorSubstituicaoTributaria        AS DEC 
   FIELD RetiraNoLocal                      AS LOG
   FIELD MetodoEntrega                      AS INT
   FIELD Transportadora                     AS INT
   FIELD Frete                              LIKE nota-fiscal.cidade-cif
   FIELD CondicaoFreteEntrega               AS INT
   FIELD CNPJ                               LIKE nota-fiscal.cgc         
   FIELD CPF                                LIKE nota-fiscal.cgc         
   FIELD InscricaoEstadual                  LIKE nota-fiscal.ins-estadual
   FIELD Oportunidade                       AS INT
   FIELD PrecoBloqueado                     AS LOG 
   FIELD ValorDesconto                      LIKE nota-fiscal.vl-desconto
   FIELD PercentualDesconto                 AS DEC   
   FIELD ListaPreco                         AS CHAR  
   FIELD Prioridade                         AS INT 
   FIELD Representante                      LIKE nota-fiscal.cod-rep
   FIELD Proprietario                       AS CHAR
   FIELD TipoProprietario                   AS CHAR
   FIELD ValorTotal                         AS DEC 
   FIELD ValorTotalImpostos                 AS DEC  /*icms + ipi + pis + cofins*/  
   FIELD ValorTotalSemImposto               AS DEC 
   FIELD ValorTotalSemFrete                 AS DEC 
   FIELD ValorTotalDesconto                 AS DEC 
   FIELD ValorTotalProdutos                 AS DEC 
   FIELD ValorTotalProdutosSemImposto       AS DEC 
   FIELD TelefoneCobranca                   AS CHAR 
   FIELD FaxCobranca                        AS CHAR
   FIELD TipoNotaFiscal                     AS INT
   FIELD IdentificadorUnicoNFE              AS CHAR
   FIELD NotaDevolucao                      AS LOG
   /*FIELD ConhecimentoTransporte             AS CHAR*/.

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
   FIELD Telefone                           AS CHAR
   FIELD Fax                                AS CHAR.

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
   FIELD Telefone                           AS CHAR
   FIELD Fax                                AS CHAR.

DEFINE TEMP-TABLE msg0094-itens NO-UNDO XML-NODE-NAME 'NotaFiscalItens'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE msg0094-item NO-UNDO XML-NODE-NAME 'NotaFiscalItem'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD ChaveIntegracao              AS CHAR
    FIELD CodigoProduto                LIKE it-nota-fisc.it-codigo     
    FIELD NomeProduto                  AS CHAR
    FIELD Descricao                    LIKE ITEM.desc-item             
    FIELD PrecoOriginal                LIKE it-nota-fisc.vl-preori     
    FIELD PrecoUnitario                LIKE it-nota-fisc.vl-preuni     
    FIELD PrecoLiquido                 AS DEC
    FIELD ValorMercadoriaTabela        AS DEC 
    FIELD ValorMercadoriaOriginal      AS DEC 
    FIELD ValorMercadoriaLiquido       AS DEC 
    FIELD CodigoNaturezaOperacao       LIKE it-nota-fisc.nat-operacao  
    FIELD NomeNaturezaOperacao         AS CHAR
    FIELD ProdutoForaCatalogo          AS LOG   
    FIELD DescricaoProdutoForaCatalogo AS CHAR
    FIELD PermiteSubstituirPreco       AS LOG 
    FIELD UnidadeMedida                AS CHAR             
    FIELD ValorBaseICMS                AS DEC 
    FIELD ValorBaseICMSSubstituicao    AS DEC 
    FIELD ValorICMS                    AS DEC 
    FIELD ValorICMSSubstituicao        AS DEC 
    FIELD ValorICMSNaoTributado        AS DEC 
    FIELD ValorICMSOutras              AS DEC 
    FIELD CodigoTributarioICMS         LIKE it-nota-fisc.cd-trib-icm           
    FIELD CodigoTributarioISS          LIKE it-nota-fisc.cd-trib-iss          
    FIELD CodigoTributarioIPI          LIKE it-nota-fisc.cd-trib-ipi         
    FIELD ValorBaseISS                 AS DEC 
    FIELD ValorBaseIPI                 AS DEC 
    FIELD AliquotaISS                  LIKE it-nota-fisc.aliquota-ISS        
    FIELD AliquotaIPI                  LIKE it-nota-fisc.aliquota-ipi        
    FIELD AliquotaICMS                 LIKE it-nota-fisc.aliquota-icm        
    FIELD ValorISS                     AS DEC 
    FIELD ValorISSNaoTributado         AS DEC 
    FIELD ValorISSOutras               AS DEC 
    FIELD ValorIPI                     AS DEC 
    FIELD ValorIPINaoTributado         AS DEC 
    FIELD ValorIPIOutras               AS DEC 
    FIELD PrecoConsumidor              AS DEC
    FIELD QuantidadeCancelada          AS DEC
    FIELD QuantidadePendente           AS DEC
    FIELD DataEntrega                  AS DATE
    FIELD CondicaoFrete                AS INT
    FIELD ValorOriginal                AS DEC 
    FIELD ValorTotalImposto            AS DEC
    FIELD ValorDescontoManual          AS DEC
    FIELD Quantidade                   AS DEC
    FIELD RetiraNoLocal                AS LOG
    FIELD QuantidadeEntregue           AS DEC
    FIELD NumeroSequencia              LIKE it-nota-fisc.nr-seq-fat
    FIELD CodigoUnidadeNegocio         LIKE it-nota-fisc.cod-unid-neg
    FIELD NomeUnidadeNegocio           AS CHAR
    FIELD CodigoRepresentante          LIKE nota-fiscal.cod-rep
    FIELD ValorTotal                   AS DEC 
    FIELD Moeda                        LIKE nota-fiscal.mo-codigo      
    FIELD Acao                         AS CHAR
    FIELD CalcularRebate               AS LOGICAL
    FIELD NumeroPedido                 LIKE it-nota-fisc.nr-pedido
    FIELD PercentualDescontoVerde      AS DEC DECIMALS 4
    FIELD PercentualDescontoTopMilhao  AS DEC DECIMALS 4
    FIELD PercentualRebateAntecipado   AS DEC DECIMALS 4.

DEFINE TEMP-TABLE msg0094r NO-UNDO XML-NODE-NAME 'MSG0094R1'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.


