
DEFINE TEMP-TABLE msg0155-status NO-UNDO XML-NODE-NAME 'MSG0155'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoSolicitacaoBeneficio            AS CHAR
    FIELD NomeSolicitacaoBeneficio              AS CHAR
    FIELD CodigoTipoSolicitacao                 AS CHAR
    FIELD CodigoBeneficio                       AS CHAR
    FIELD BeneficioCodigo                       AS INT
    FIELD CodigoBeneficioCanal                  AS CHAR
    FIELD CodigoUnidadeNegocio                  AS CHAR
    FIELD CodigoConta                           AS CHAR
    FIELD ValorSolicitado                       AS DEC DECIMALS 4
    FIELD ValorAprovado                         AS DEC DECIMALS 4
    FIELD DescricaoSolicitacao                  AS CHAR
    FIELD SolicitacaoIrregular                  AS LOG
    FIELD DescricaoSituacaoIrregular            AS CHAR
    FIELD CodigoAcaoSubsidiadaVMC               AS CHAR                     XML-NODE-TYPE 'HIDDEN'
    FIELD DataPrevistaRetornoAcao               AS DATE FORMAT "99/99/9999" XML-NODE-TYPE 'HIDDEN'
    FIELD ValorAcao                             AS DEC DECIMALS 4           XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoFormaPagamento                  AS CHAR
    FIELD SituacaoSolicitacaoBeneficio          AS INT
    FIELD RazaoStatusSolicitacaoBeneficio       AS INT
    FIELD Situacao                              AS INT
    FIELD Proprietario                          AS CHAR
    FIELD TipoProprietario                      AS CHAR
    FIELD CodigoAssistente                      AS INT
    FIELD CodigoSupervisorEMS                   AS CHAR
    FIELD CodigoFilial                          AS CHAR
    FIELD StatusPagamento                       AS INT
    FIELD SolicitacaoAjuste                     AS LOG
    FIELD ValorAbater                           AS DEC DECIMALS 4
    FIELD ValorPago                             AS DEC DECIMALS 4
    FIELD ValorCancelado                        AS DEC DECIMALS 4
    FIELD DataCriacao                           AS DATE
    FIELD DataValidade                          AS DATE
    FIELD CodigoCondicaoPagamento               AS INTEGER INIT ?
    FIELD DescartarVerba                        AS LOG
    FIELD TrimestreCompetencia                  AS CHAR
    FIELD FormaCancelamento                     AS INTEGER INIT ?
    FIELD StatusCalculoPriceProtection          AS INTEGER INIT ?.

DEFINE TEMP-TABLE msg0155-ProdutoSolicitacaoItens NO-UNDO XML-NODE-NAME 'ProdutoSolicitacaoItens'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE msg0155-ProdutoSolicitacaoItem NO-UNDO XML-NODE-NAME 'ProdutoSolicitacaoItem'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoProdutoSolicitacao              AS CHAR
   FIELD CodigoSolicitacaoBeneficio            AS CHAR
   FIELD CodigoProduto                         AS CHAR
   FIELD CodigoBeneficio                       AS CHAR
   FIELD ValorUnitario                         AS DEC DECIMALS 4
   FIELD Quantidade                            AS INT
   FIELD ValorTotal                            AS DEC DECIMALS 4
   FIELD ValorUnitarioAprovado                 AS DEC DECIMALS 4
   FIELD QuantidadeAprovado                    AS INT 
   FIELD ValorTotalAprovado                    AS DEC DECIMALS 4
   FIELD ChaveIntegracaoNotaFiscal             AS CHAR 
   FIELD Proprietario                          AS CHAR
   FIELD TipoProprietario                      AS CHAR
   FIELD Acao                                  AS CHAR
   FIELD CodigoEstabelecimento                 AS INT
   FIELD Situacao                              AS INT
   FIELD QuantidadeCancelada                   AS DEC DECIMALS 4
   FIELD ValorPago                             AS DEC DECIMALS 4
   FIELD ValorCancelado                        AS DEC DECIMALS 4
   FIELD QuantidadeAjustada                    AS DEC DECIMALS 5 INIT ?. 


DEFINE TEMP-TABLE msg0155-statusr NO-UNDO XML-NODE-NAME 'MSG0155R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoBeneficio            AS CHAR
   FIELD proprietario                          AS CHAR
   FIELD tipo-proprietario                     AS CHAR.
