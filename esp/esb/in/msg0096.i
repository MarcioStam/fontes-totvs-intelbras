{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0096r NO-UNDO XML-NODE-NAME 'MSG0096R1'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE msg0096R-nota NO-UNDO XML-NODE-NAME 'NotaFiscal'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroNotaFiscal                   LIKE nota-fiscal.nr-nota-fis    
   FIELD Nome                               AS CHAR
   FIELD NumeroSerie                        LIKE nota-fiscal.serie        
   FIELD CodigoClienteCRM                   AS CHAR
   FIELD TipoObjetoCliente                  AS CHAR
   FIELD NumeroPedido                       LIKE ped-venda.nr-pedido        
   FIELD NumeroPedidoCliente                LIKE nota-fiscal.nr-pedcli      
   FIELD Descricao                          AS CHAR
   FIELD CodigoEstabelecimento              LIKE nota-fiscal.cod-estabel    
   FIELD NomeEstabelecimento                LIKE estabelec.nome
   FIELD CodigoCondicaoPagamento            LIKE nota-fiscal.cod-cond-pag   
   FIELD NomeCondicaoPagamento              AS CHAR
   FIELD NomeAbreviadoCliente               LIKE nota-fiscal.nome-ab-cli    
   FIELD CodigoNaturezaOperacao             LIKE nota-fiscal.nat-operacao   
   FIELD NomeNaturezaOperacao               AS CHAR
   FIELD Moeda                              LIKE nota-fiscal.mo-codigo      
   FIELD SituacaoNota                       AS INT
   FIELD SituacaoEntrega                    AS INT
   FIELD DataEmissao                        LIKE nota-fiscal.dt-emis-nota
   FIELD DataSaida                          LIKE nota-fiscal.dt-saida
   FIELD DataEntrega                        AS DATE 
   FIELD DataConfirmacao                    LIKE nota-fiscal.dt-confirma
   FIELD DataCancelamento                   LIKE nota-fiscal.dt-cancel
   FIELD DataConclusao                      AS DATE
   FIELD ValorFrete                         LIKE nota-fiscal.vl-frete     
   FIELD PesoLiquido                        LIKE nota-fiscal.peso-liq-tot 
   FIELD PesoBruto                          LIKE nota-fiscal.peso-bru-tot 
   FIELD Observacao                         LIKE nota-fiscal.observ-nota   
   FIELD Volume                             AS CHAR
   FIELD ValorBaseICMS                      LIKE it-nota-fisc.vl-bicms-it
   FIELD ValorICMS                          LIKE it-nota-fisc.vl-icms-it
   FIELD ValorIPI                           LIKE it-nota-fisc.vl-ipi-it
   FIELD ValorBaseSubstituicaoTributaria    AS DEC 
   FIELD ValorSubstituicaoTributaria        LIKE it-nota-fisc.vl-icmsub-it    
   FIELD RetiraNoLocal                      AS LOG
   FIELD MetodoEntrega                      AS INT
   FIELD CodigoTransportadora               LIKE nota-fiscal.nome-transp
   FIELD NomeTransportadora                 AS CHAR
   FIELD Frete                              LIKE nota-fiscal.cidade-cif
   FIELD CondicaoFreteEntrega               AS INT
   FIELD CNPJ                               LIKE nota-fiscal.cgc         
   FIELD CPF                                LIKE nota-fiscal.cgc         
   FIELD InscricaoEstadual                  LIKE nota-fiscal.ins-estadual
   FIELD CodigoOportunidade                 AS INT
   FIELD NomeOportunidade                   AS CHAR
   FIELD PrecoBloqueado                     AS LOG 
   FIELD ValorDesconto                      LIKE nota-fiscal.vl-desconto
   FIELD PercentualDesconto                 AS DEC   
   FIELD ListaPreco                         AS CHAR  
   FIELD Prioridade                         AS INT 
   FIELD CodigoRepresentante                LIKE nota-fiscal.cod-rep
   FIELD NomeRepresentante                  AS CHAR
   FIELD ValorTotal                         LIKE nota-fiscal.vl-tot-nota  
   FIELD ValorTotalImpostos                 AS DEC  /*icms + ipi + pis + cofins*/  
   FIELD ValorTotalSemImposto               LIKE nota-fiscal.vl-mercad 
   FIELD ValorTotalSemFrete                 LIKE nota-fiscal.vl-tot-nota  
   FIELD ValorTotalDesconto                 LIKE nota-fiscal.vl-desconto
   FIELD ValorTotalProdutos                 LIKE nota-fiscal.vl-tot-nota  
   FIELD ValorTotalProdutosSemImposto       LIKE nota-fiscal.vl-mercad    
   FIELD TelefoneCobranca                   LIKE emitente.telefone[1]
   FIELD FaxCobranca                        LIKE emitente.telefax
   FIELD TipoNotaFiscal                     AS INTEGER
   FIELD NotaDevolucao                      AS LOG .

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

DEFINE TEMP-TABLE msg0096R-itens NO-UNDO XML-NODE-NAME 'NotaFiscalItens'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE msg0096R-item NO-UNDO XML-NODE-NAME 'NotaFiscalItem'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD ChaveIntegracao              AS CHAR
    FIELD CodigoProduto                LIKE it-nota-fisc.it-codigo     
    FIELD NomeProduto                  LIKE ITEM.desc-item             
    FIELD Descricao                    AS CHAR
    FIELD PrecoOriginal                LIKE it-nota-fisc.vl-preori     
    FIELD PrecoUnitario                LIKE it-nota-fisc.vl-preuni     
    FIELD PrecoLiquido                 AS DEC
    FIELD ValorMercadoriaTabela        LIKE it-nota-fisc.vl-pretab     
    FIELD ValorMercadoriaOriginal      LIKE it-nota-fisc.vl-merc-ori   
    FIELD ValorMercadoriaLiquido       LIKE it-nota-fisc.vl-merc-liq   
    FIELD CodigoNaturezaOperacao       LIKE it-nota-fisc.nat-operacao  
    FIELD NomeNaturezaOperacao         AS CHAR
    FIELD ProdutoForaCatalogo          AS LOG   
    FIELD DescricaoProdutoForaCatalogo AS CHAR
    FIELD PermiteSubstituirPreco       AS LOG 
    FIELD UnidadeMedida                LIKE it-nota-fisc.un-fatur[1]
    FIELD ValorBaseICMS                LIKE it-nota-fisc.vl-bicms-it          
    FIELD ValorBaseICMSSubstituicao    LIKE It-nota-fisc.vl-bicms-it        
    FIELD ValorICMS                    LIKE it-nota-fisc.vl-icms-it          
    FIELD ValorICMSSubstituicao        LIKE it-nota-fisc.vl-icmsub-it        
    FIELD ValorICMSNaoTributado        LIKE it-nota-fisc.vl-icmsnt-it          
    FIELD ValorICMSOutras              LIKE it-nota-fisc.vl-icmsou-it         
    FIELD CodigoTributarioICMS         LIKE it-nota-fisc.cd-trib-icm           
    FIELD CodigoTributarioISS          LIKE it-nota-fisc.cd-trib-iss          
    FIELD CodigoTributarioIPI          LIKE it-nota-fisc.cd-trib-ipi         
    FIELD ValorBaseISS                 LIKE it-nota-fisc.vl-biss-it          
    FIELD ValorBaseIPI                 LIKE it-nota-fisc.vl-bipi-it
    FIELD AliquotaISS                  LIKE it-nota-fisc.aliquota-ISS        
    FIELD AliquotaIPI                  LIKE it-nota-fisc.aliquota-ipi        
    FIELD AliquotaICMS                 LIKE it-nota-fisc.aliquota-icm        
    FIELD ValorISS                     LIKE it-nota-fisc.vl-iss-it           
    FIELD ValorISSNaoTributado         LIKE it-nota-fisc.vl-issnt-it         
    FIELD ValorISSOutras               LIKE it-nota-fisc.vl-issou-it         
    FIELD ValorIPI                     LIKE it-nota-fisc.vl-ipi-it           
    FIELD ValorIPINaoTributado         LIKE it-nota-fisc.vl-ipint-it        
    FIELD ValorIPIOutras               LIKE it-nota-fisc.vl-ipiou-it      
    FIELD PrecoConsumidor              AS DEC
    FIELD QuantidadeCancelada          AS DEC
    FIELD QuantidadePendente           AS DEC
    FIELD DataEntrega                  AS DATE
    FIELD CondicaoFrete                AS INT
    FIELD ValorOriginal                LIKE it-nota-fisc.vl-merc-ori
    FIELD ValorTotalImposto            AS DEC
    FIELD ValorDescontoManual          AS DEC
    FIELD Quantidade                   AS DEC
    FIELD RetiraNoLocal                AS LOG
    FIELD QuantidadeEntregue           AS DEC
    FIELD NumeroSequencia              LIKE it-nota-fisc.nr-seq-fat
    FIELD CodigoUnidadeNegocio         LIKE it-nota-fisc.cod-unid-neg
    FIELD NomeUnidadeNegocio           AS CHAR
    FIELD CodigoRepresentante          LIKE nota-fiscal.cod-rep
    FIELD NomeRepresentante            AS CHAR
    FIELD ValorTotal                   LIKE nota-fiscal.vl-tot-nota  
    FIELD Moeda                        LIKE nota-fiscal.mo-codigo      
    FIELD Acao                         AS CHAR.

DEFINE TEMP-TABLE msg0096 NO-UNDO XML-NODE-NAME 'MSG0096'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD NumeroNotaFiscal LIKE nota-fiscal.nr-nota-fis.



