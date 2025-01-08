

DEFINE TEMP-TABLE msg0152-ProdutoSolicitacaoItens NO-UNDO XML-NODE-NAME 'ProdutoSolicitacaoItens'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE msg0152-ProdutoSolicitacaoItem NO-UNDO XML-NODE-NAME 'ProdutoSolicitacaoItem'
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
                                   
DEFINE TEMP-TABLE msg0152r1 NO-UNDO XML-NODE-NAME 'MSG0152R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoBeneficio            AS CHAR INIT ?
   FIELD Proprietario                          AS CHAR INIT ?
   FIELD TipoProprietario                      AS CHAR INIT ?.

DEFINE TEMP-TABLE msg0152r1-SaldoBeneficioCanal NO-UNDO XML-NODE-NAME 'SaldoBeneficioCanal'
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
