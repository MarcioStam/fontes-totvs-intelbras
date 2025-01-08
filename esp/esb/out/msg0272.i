DEFINE TEMP-TABLE msg0272 NO-UNDO XML-NODE-NAME 'MSG0272'
    FIELD idm               AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoARB         LIKE int_solicitacao_alatur.request_number_arb.
                                   
DEFINE TEMP-TABLE msg0272r NO-UNDO XML-NODE-NAME 'MSG0272R1'
    FIELD idm               AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoARB                       LIKE int_solicitacao_alatur.request_number                        
    FIELD NomeEmpresa                     LIKE int_solicitacao_alatur.request_company_name                  
    FIELD NomeCentroCusto                 LIKE int_solicitacao_alatur.account_name                          
    FIELD CPF                             LIKE int_solicitacao_alatur.request_passenger_CPF                 
    FIELD NumeroBanco                     LIKE int_solicitacao_alatur.request_passenger_bank                
    FIELD NumeroAgencia                   LIKE int_solicitacao_alatur.request_passenger_branch_number       
    FIELD NumeroContaCorrente             LIKE int_solicitacao_alatur.request_passenger_checking_acc   
    FIELD DescricaoDespesa                LIKE int_solicitacao_alatur.advance_expense                       
    FIELD DataHoraFinalAdiantamento       LIKE int_solicitacao_alatur.advance_final_date                    
    FIELD DataHoraSolicitacaoAdiantamento LIKE int_solicitacao_alatur.advance_include_date                  
    FIELD DataHoraInicialAdiantamento     LIKE int_solicitacao_alatur.advance_initial_date                  
    FIELD Observacao                      LIKE int_solicitacao_alatur.advance_note                          
    FIELD ValorAdiantamento               LIKE int_solicitacao_alatur.advance_price                         
    FIELD QuantidadeAdiantamento          LIKE int_solicitacao_alatur.advance_quantity
    FIELD DescricaoSolicitacao            LIKE int_solicitacao_alatur.request_description.

DEFINE TEMP-TABLE ListaCentroCusto NO-UNDO XML-NODE-NAME 'ListaCentroCusto'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE CentroCusto NO-UNDO XML-NODE-NAME 'CentroCusto'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoCentroCusto AS CHAR /*advance_hitor_rateio*/
    FIELD NomeEmpresaRateio AS CHAR /*advance_hitor_rateio*/             
    FIELD PorcentagemDebito AS DEC  /*advance_hitor_rateio*/.

DEFINE TEMP-TABLE ListaReembolsos NO-UNDO XML-NODE-NAME 'ListaReembolsos'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'.

DEFINE TEMP-TABLE Reembolso NO-UNDO XML-NODE-NAME 'Reembolso'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoContaContabil AS CHAR /*refund_histor_rateio*/
    FIELD ValorDespesa        AS DEC  /*refund_histor_rateio*/
    FIELD QuantidadeDespesa   AS INT  /*refund_histor_rateio*/.    
