
DEFINE TEMP-TABLE msg0154 NO-UNDO XML-NODE-NAME 'MSG0154'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoBeneficio            AS CHAR
   FIELD NomeSolicitacaoBeneficio              AS CHAR
   FIELD CodigoTipoSolicitacao                 AS CHAR 
   FIELD CodigoBeneficio                       AS CHAR
   FIELD CodigoBeneficioCanal                  AS CHAR
   FIELD BeneficioCodigo                       AS INT
   FIELD CodigoUnidadeNegocio                  AS CHAR
   FIELD CodigoConta                           AS CHAR
   FIELD ValorSolicitado                       AS DEC DECIMALS 4
   FIELD ValorAprovado                         AS DEC DECIMALS 4
   FIELD DescricaoSolicitacao                  AS CHAR
   FIELD SolicitacaoIrregular                  AS LOG
   FIELD DescricaoSituacaoIrregular            AS CHAR
   FIELD CodigoFormaPagamento                  AS CHAR
   FIELD SituacaoSolicitacaoBeneficio          AS INT
   FIELD RazaoStatusSolicitacaoBeneficio       AS INT
   FIELD situacao                              AS INT
   FIELD Proprietario                          AS CHAR
   FIELD TipoProprietario                      AS CHAR
   FIELD CodigoAssistente                      AS INT
   FIELD CodigoSupervisorEMS                   AS CHAR
   FIELD CodigoFilial                          AS CHAR
   FIELD StatusPagamento                       as INT
   FIELD SolicitacaoAjuste                     AS LOG 
   FIELD ValorAbater                           AS DEC DECIMALS 4
   FIELD ValorPago                             AS DEC DECIMALS 4
   FIELD ValorCancelado                        AS DEC DECIMALS 4
   FIELD DataCriacao                           AS DATE
   FIELD DataValidade                          AS DATE
   FIELD CodigoCondicaoPagamento               AS INTEGER INIT ?
   FIELD DescartarVerba                        AS LOG
   FIELD TrimestreCompetencia                  AS CHAR
   FIELD FormaCancelamento                     AS INTEGER INIT ?.

                                         
DEFINE TEMP-TABLE msg0154-ProdutoSolicitacaoItens NO-UNDO XML-NODE-NAME 'ProdutoSolicitacaoItens'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE msg0154-ProdutoSolicitacaoItem NO-UNDO XML-NODE-NAME 'ProdutoSolicitacaoItem'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProdutoSolicitacao              AS CHAR
   FIELD CodigoSolicitacaoBeneficio            AS CHAR
   FIELD CodigoProduto                         AS CHAR
   FIELD CodigoBeneficio                       AS CHAR
   FIELD ValorUnitario                         AS DEC DECIMALS 4
   FIELD quantidade                            AS INT
   FIELD ValorTotal                            AS DEC DECIMALS 4
   FIELD ValorUnitarioAprovado                 AS DEC DECIMALS 4
   FIELD QuantidadeAprovado                    AS INT 
   FIELD ValorTotalAprovado                    AS DEC DECIMALS 4
   FIELD ChaveIntegracaoNotaFiscal             AS CHAR
   FIELD proprietario                          AS CHAR
   FIELD TipoProprietario                      AS CHAR
   FIELD acao                                  AS CHAR
   FIELD CodigoEstabelecimento                 AS INT
   FIELD Situacao                              AS INT
   FIELD QuantidadeCancelada                   AS DEC DECIMALS 4
   FIELD ValorPago                             AS DEC DECIMALS 4
   FIELD ValorCancelado                        AS DEC DECIMALS 4
   FIELD QuantidadeAjustada                    AS DEC DECIMALS 5 INIT ?. 

                                   
DEFINE TEMP-TABLE msg0154r1 NO-UNDO XML-NODE-NAME 'MSG0154R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoBeneficio            AS CHAR  INIT ?
   FIELD Proprietario                          AS CHAR  INIT ?
   FIELD TipoProprietario                      AS CHAR  INIT ?.

DEFINE TEMP-TABLE msg0154r1-SaldoBeneficioCanal NO-UNDO XML-NODE-NAME 'SaldoBeneficioCanal'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoBeneficioCanal        AS CHAR INIT ?
   FIELD VerbaCalculada              AS DEC
   FIELD VerbaPeriodoAnterior        AS DEC
   FIELD VerbaTotal                  AS DEC
   FIELD VerbaEmpenhada              AS DEC
   FIELD VerbaReembolsada            AS DEC
   FIELD VerbaCancelada              AS DEC
   FIELD VerbaAjustada               AS DEC
   FIELD VerbaDisponivel             AS DEC.
