
DEFINE TEMP-TABLE EnderecoPrincipal NO-UNDO XML-NODE-NAME 'EnderecoPrincipal'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NomeEndereco                       LIKE emitente.nome-emit    INITIAL ?
   FIELD TipoEndereco                       AS INT                     INITIAL 3
   FIELD CaixaPostal                        AS CHAR                    INITIAL ?
   FIELD CEP                                LIKE nota-fiscal.cep       INITIAL ?
   FIELD Logradouro                         AS CHAR                    INITIAL ?
   FIELD Numero                             AS CHAR                    INITIAL ?
   FIELD Complemento                        AS CHAR                    INITIAL ?
   FIELD Bairro                             LIKE nota-fiscal.bairro    INITIAL ?
   FIELD NomeCidade                         LIKE nota-fiscal.cidade    INITIAL ?
   FIELD Cidade                             LIKE nota-fiscal.cidade    INITIAL ?
   FIELD UF                                 LIKE nota-fiscal.estado    INITIAL ?
   FIELD Estado                             LIKE nota-fiscal.estado    INITIAL ?
   FIELD NomePais                           LIKE nota-fiscal.pais      INITIAL ?
   FIELD Pais                               LIKE nota-fiscal.pais
   FIELD NomeContato                        AS CHAR                    INITIAL ?
   FIELD Telefone                           LIKE emitente.telefone[1]  INITIAL ?
   FIELD Fax                                LIKE emitente.telefax      INITIAL ?.

DEFINE TEMP-TABLE EnderecoCobranca NO-UNDO XML-NODE-NAME 'EnderecoCobranca'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD NomeEndereco                       LIKE emitente.nome-emit   INITIAL ?
   FIELD TipoEndereco                       AS INT                    INITIAL 993520000
   FIELD CaixaPostal                        AS CHAR                   INITIAL ?
   FIELD CEP                                LIKE nota-fiscal.cep      INITIAL ?
   FIELD Logradouro                         AS CHAR                   INITIAL ?
   FIELD Numero                             AS CHAR                   INITIAL ?
   FIELD Complemento                        AS CHAR                   INITIAL ?
   FIELD Bairro                             LIKE nota-fiscal.bairro   INITIAL ? 
   FIELD NomeCidade                         LIKE nota-fiscal.cidade   INITIAL ? 
   FIELD Cidade                             LIKE nota-fiscal.cidade   INITIAL ? 
   FIELD UF                                 LIKE nota-fiscal.estado   INITIAL ? 
   FIELD Estado                             LIKE nota-fiscal.estado   INITIAL ? 
   FIELD NomePais                           LIKE nota-fiscal.pais     INITIAL ? 
   FIELD Pais                               LIKE nota-fiscal.pais
   FIELD NomeContato                        AS CHAR                   INITIAL ?
   FIELD Telefone                           LIKE emitente.telefone[1] INITIAL ? 
   FIELD Fax                                LIKE emitente.telefax     INITIAL ?.

DEFINE TEMP-TABLE DadosFornecedor NO-UNDO XML-NODE-NAME 'DadosFornecedor'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD ParticipaPortalFornecedores   AS INT
   FIELD SituacaoCompras               AS INT
   FIELD TaxaFinanceira                LIKE emitente.taxa-financ   
   FIELD CodigoGrupoFornecedores       LIKE emitente.cod-gr-forn 
   FIELD DescricaoGrupoFornecedores    LIKE grupo-fornec.descricao
   FIELD Observacoes                   LIKE emitente.observacoes            
   FIELD NomeMatriz                    LIKE emitente.nome-matriz             
   FIELD DiasTaxaFinanceira            LIKE emitente.nr-dias-taxa            
   FIELD CodigoTipoDespesaPadrao       LIKE emitente.tp-desp-padrao          
   FIELD DescricaoTipoDespesaPadrao    LIKE tipo-rec-desp.descricao          
   FIELD CodigoTipoPagamento           LIKE emitente.tp-pagto                
   FIELD TributacaoCOFINS              LIKE emitente.idi-tributac-cofins     
   FIELD TributacaoPIS                 LIKE emitente.idi-tributac-pis        
   FIELD FornecedorEmiteNFECTE         LIKE emitente.log-possui-nf-eletro    
   FIELD Forecasting                   LIKE int-emitente.forecasting         
   FIELD MesesForecast                 LIKE int-emitente.meses-forcast       
   FIELD DataUltimaAtualizacao         LIKE int-emitente.dt-ult-atualizacao 
   FIELD CodigoABA                     LIKE emitente-cex.cod-aba             
   FIELD CodigoItinerario              LIKE emitente-cex.cod-itiner-imp      
   FIELD DescricaoItinerario           LIKE itinerario.descricao             
   FIELD CodigoIncoterm                LIKE emitente-cex.cod-incoterm-imp    
   FIELD DescricaoIncoterm             LIKE inco-cx.descricao
   FIELD CodigoPontoControleBase       LIKE emitente-cex.cod-pto-contr
   FIELD DescricaoPontoControleBase    LIKE pto-contr.descricao
   FIELD CodigoDespachante             LIKE emitente-cex.cdn-despa-import          
   FIELD CodigoDespachanteExterior     LIKE emitente-cex.cdn-despa-exter-import    
   FIELD CodigoSeguradora              LIKE emitente-cex.cdn-segurad-import        
   FIELD CodigoCorretorCambio          LIKE emitente-cex.cdn-corretor-cambio-import
   FIELD CodigoCorretorSeguro          LIKE emitente-cex.cdn-corretor-import
   FIELD Fornecimento                  AS CHAR
   FIELD Cooperativa                   AS LOG
   FIELD AssociacaoDesportiva          AS LOG
   FIELD AtivoFornecedor               LIKE int-emitente.id-ativo-forn.          


DEFINE TEMP-TABLE msg0072r NO-UNDO XML-NODE-NAME 'MSG0072R1'
   FIELD idm AS INT XML-NODE-TYPE 'hidden'
   FIELD CodigoConta      AS CHAR
   FIELD CodigoCliente    LIKE emitente.cod-emitente
   FIELD Proprietario     AS CHAR
   FIELD TipoProprietario AS CHAR
   FIELD NomeAbreviado    AS CHAR
   FIELD NomeAbreviadoMatrizEconomica AS CHAR.

DEFINE TEMP-TABLE tt-erro  NO-UNDO
       FIELD codigo     AS INT
       FIELD informacao AS CHAR
       FIELD mensagem   AS CHARACTER FORMAT "x(250)".

/*Defini»’o das temp-tables de valida»’o - cdp/cdapi329.p*/
DEFINE TEMP-TABLE tt-versao-integr NO-UNDO
    FIELD cod-versao-integracao AS INTEGER FORMAT "999":U
    FIELD ind-origem-msg        AS INTEGER FORMAT "99":U.

DEFINE TEMP-TABLE tt-erros-geral NO-UNDO
    FIELD identif-msg        AS CHARACTER FORMAT "x(60)":U
    FIELD num-sequencia-erro AS INTEGER   FORMAT "999":U
    FIELD cod-erro           AS INTEGER   FORMAT "99999":U
    FIELD des-erro           AS CHARACTER FORMAT "x(60)":U
    FIELD cod-maq-origem     AS INTEGER   FORMAT "999":U
    FIELD num-processo       AS INTEGER   FORMAT "999999999":U.

DEFINE TEMP-TABLE tt-cliente-valid NO-UNDO LIKE emitente
    FIELD cod-maq-origem AS INTEGER   FORMAT "9999":U
    FIELD num-processo   AS INTEGER   FORMAT ">>>>>>>>9":U INITIAL 0
    FIELD num-sequencia  AS INTEGER   FORMAT ">>>>>9":U    INITIAL 0
    FIELD ind-tipo-movto AS INTEGER   FORMAT "99":U        INITIAL 1
    INDEX ch-codigo IS PRIMARY
          cod-maq-origem
          num-processo
          num-sequencia.
        
def temp-table tt-loc-entr-valid like loc-entr
    FIELD cod-maq-origem   as   integer format "9999"
    FIELD num-processo     as   integer format ">>>>>>>>9" initial 0
    FIELD num-sequencia    as   integer format ">>>>>9"    initial 0
    FIELD ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.  

DEFINE TEMP-TABLE tt-dist-emit-valid NO-UNDO LIKE dist-emitente
    FIELD cod-maq-origem AS INTEGER   FORMAT "9999":U
    FIELD num-processo   AS INTEGER   FORMAT ">>>>>>>>9":U INITIAL 0
    FIELD num-sequencia  AS INTEGER   FORMAT ">>>>>9":U    INITIAL 0
    FIELD ind-tipo-movto AS INTEGER   FORMAT "99":U        INITIAL 1
    INDEX ch-codigo IS PRIMARY
        cod-maq-origem
        num-processo
        num-sequencia.

DEFINE TEMP-TABLE RowErrors NO-UNDO
            FIELD ErrorSequence    AS INTEGER
            FIELD ErrorNumber      AS INTEGER
            FIELD ErrorDescription AS CHARACTER
            FIELD ErrorParameters  AS CHARACTER
            FIELD ErrorType        AS CHARACTER
            FIELD ErrorHelp        AS CHARACTER
            FIELD ErrorSubType     AS CHARACTER
            index seq ErrorSequence.
