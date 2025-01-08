
DEFINE TEMP-TABLE msg0152-status NO-UNDO XML-NODE-NAME 'MSG0152'
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
    FIELD CodigoAcaoSubsidiadaVMC               AS CHAR                     
    FIELD DataPrevistaRetornoAcao               AS DATE FORMAT "99/99/9999" 
    FIELD ValorAcao                             AS DEC DECIMALS 4           
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
    FIELD CodigoCondicaoPagamento               AS INTEGER
    FIELD DescartarVerba                        AS LOG
    FIELD TrimestreCompetencia                  AS CHAR
    FIELD FormaCancelamento                     AS INTEGER.

DEFINE TEMP-TABLE MSG0152-statusr NO-UNDO XML-NODE-NAME 'MSG0152R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoBeneficio            AS CHAR
   FIELD proprietario                          AS CHAR
   FIELD tipo-proprietario                     AS CHAR.
