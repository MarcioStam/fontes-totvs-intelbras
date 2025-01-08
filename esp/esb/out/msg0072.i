{esp/esb/esesb000.i}

DEFINE TEMP-TABLE msg0072 NO-UNDO XML-NODE-NAME 'MSG0072'
   FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoConta                     AS CHAR                         INITIAL ?
   FIELD CodigoCliente                   LIKE emitente.cod-emitente      INITIAL ?
   FIELD ContaPrimaria                   AS CHAR                         INITIAL ?
   FIELD NomeRazaoSocial                 LIKE emitente.nome-emit         INITIAL ?          
   FIELD NomeFantasia                    LIKE emitente.nom-fantasia      INITIAL ?
   FIELD NomeAbreviado                   LIKE emitente.nome-abrev        INITIAL ?
   FIELD DescricaoConta                  AS CHAR                         INITIAL ?
   FIELD TipoRelacao                     AS INT                          INITIAL ?
   FIELD NumeroBanco                     LIKE emitente.cod-banco         INITIAL ?
   FIELD NumeroAgencia                   LIKE emitente.agencia           INITIAL ?
   FIELD NumeroContaCorrente             LIKE emitente.conta-corren      INITIAL ?
   FIELD EmiteBloqueto                   LIKE emitente.emite-bloq        INITIAL ?
   FIELD GeraAvisoCredito                LIKE emitente.gera-ad           INITIAL ?
   FIELD CalculaMulta                    LIKE emitente.calcula-multa     INITIAL ?
   FIELD RecebeInformacaoSCI             LIKE emitente.recebe-inf-sci    INITIAL ?
   FIELD Telefone                        AS CHAR                         INITIAL ?
   FIELD Ramal                           AS CHAR                         INITIAL ?
   FIELD TelefoneAlternativo             AS CHAR                         INITIAL ?
   FIELD RamalTelefoneAlternativo        AS CHAR                         INITIAL ?
   FIELD Fax                             AS CHAR                         INITIAL ?
   FIELD RamalFax                        AS CHAR                         INITIAL ?
   FIELD Email                           LIKE emitente.e-mail            INITIAL ?    
   FIELD Site                            LIKE emitente.home-page         INITIAL ?
   FIELD Natureza                        AS INT                          INITIAL ?
   FIELD CNPJ                            LIKE emitente.cgc               INITIAL ?
   FIELD InscricaoEstadual               LIKE emitente.ins-estadual      INITIAL ?
   FIELD InscricaoMunicipal              LIKE emitente.ins-municipal     INITIAL ?
   FIELD SuspensaoCredito                AS LOG                          
   FIELD LimiteCredito                   AS DEC /**/                     
   FIELD DataLimiteCredito               AS DATE                         INITIAL ?
   FIELD SaldoCredito                    AS DEC /**/                     
   FIELD ModalidadeCobranca              LIKE emitente.modalidade        INITIAL ?             
   FIELD ContribuinteICMS                LIKE emitente.contrib-icms      INITIAL ? 
   FIELD CodigoSUFRAMA                   LIKE emitente.cod-suframa       INITIAL ? 
   FIELD InscricaoSubstituicaoTributaria LIKE emitente.insc-subs-trib    INITIAL ? 
   FIELD OptanteSuspensaoIPI             AS LOG                          INITIAL ?
   FIELD AgenteRetencao                  LIKE emitente.agente-retencao   INITIAL ?
   FIELD PisCofinsUnidade                AS LOG                          INITIAL ?
   FIELD RecebeNotaFiscalEletronica      LIKE emitente.log-nf-eletro     INITIAL ?
   FIELD FormaTributacao                 LIKE int-emitente.ind-forma-tributo   INITIAL ?
   FIELD ObservacaoPedido                LIKE int-emitente.observacao-ped      INITIAL ?
   FIELD TipoEmbalagem                   LIKE int-emitente.tipo-embalagem      INITIAL ?
   FIELD CodigoIncoterm                  LIKE emitente-cex.cod-incoterm-exp    INITIAL ?
   FIELD LocalEmbarque                   LIKE int-emitente-cex.local-embarque  INITIAL ?
   FIELD ViaEmbarque                     LIKE int-emitente-cex.embarque-via    INITIAL ?
   FIELD DataImplantacao                 LIKE emitente.data-implant            INITIAL ?
   FIELD CPF                             LIKE emitente.cgc                     INITIAL ?
   FIELD RG                              AS CHAR                               INITIAL ?
   FIELD OrgaoExpeditor                  AS CHAR                               INITIAL ?
   FIELD DataVencimentoConcessao         LIKE int-emitente.dt-vcto-concessao   INITIAL ?
   FIELD DescontoAssistenciaTecnica      AS DEC                                
   FIELD CoberturaGeografica             AS CHAR                               INITIAL ?
   FIELD DataConstituicao                AS DATE                               INITIAL ?
   FIELD DistribuicaoUnicaFonteReceita   AS LOG                                
   FIELD DistribuidorPrincipal           AS CHAR                               INITIAL ?
   FIELD QualificadoTreinamento          AS CHAR                               INITIAL ?
   FIELD Exclusividade                   AS LOG                                INITIAL ?
   FIELD Historico                       AS CHAR                               INITIAL ?
   FIELD IntencaoApoio                   AS CHAR                               INITIAL ?
   FIELD MetodoComercializacao           AS CHAR                               INITIAL ?
   FIELD ModeloOperacao                  AS CHAR                               INITIAL ?
   FIELD NumeroFuncionarios              AS INT                                
   FIELD NumeroColaboradoresAreaTecnica  AS INT                                
   FIELD NumeroRevendasAtivas            AS INT                                
   FIELD NumeroRevendasInativas          AS CHAR                               INITIAL ?
   FIELD NumeroTecnicosSuporte           AS INT                                
   FIELD NumeroVendedores                AS INT                                
   FIELD OutraFonteReceita               AS CHAR                               INITIAL ?
   FIELD ParticipaProgramaCanais         AS INT                                INITIAL ?
   FIELD PerfilRevendasDistribuidor      AS CHAR                               INITIAL ?
   FIELD PossuiEstruturaCompleta         AS INT                                INITIAL 993520001
   FIELD PossuiFiliais                   AS INT                                INITIAL 993520001
   FIELD QuantidadeFiliais               AS INT                                
   FIELD PrazoMedioCompra                AS DEC                                
   FIELD PrazoMedioVenda                 AS DEC                                
   FIELD Setor                           AS INT                                INITIAL ?
   FIELD RamoAtividadeEconomica          AS CHAR                               INITIAL ?
   FIELD SistemaGestao                   AS CHAR                               INITIAL ?
   FIELD ValorMedioCompra                AS DEC                                
   FIELD ValorMedioVenda                 AS DEC                                
   FIELD VendeAtacadista                 AS LOG                                INITIAL ?
   FIELD ListaPreco                      AS CHAR                               INITIAL ?
   FIELD ObservacaoNotaFiscal            AS CHAR                               INITIAL ?
   FIELD EstruturaPropriedade            AS INT                                INITIAL ?
   FIELD ReceitaAnual                    AS DEC                                
   FIELD CNAE                            AS CHAR                               INITIAL ?
   FIELD Situacao                        AS INT                                INITIAL ?
   FIELD Classificacao                   LIKE int-emitente.guid-class          INITIAL ?
   FIELD SubClassificacao                LIKE int-emitente.guid-subclass       INITIAL ?
   FIELD Portador                        LIKE emitente.portador                INITIAL ?
   FIELD NivelPosVenda                   AS CHAR INITIAL "37E3A262-75ED-E311-9407-00155D013D38" /*Inicia com n¡vel 0, pois o Totvs nao tem essa informa‡Æo*/
   FIELD ReceitaPadrao                   AS INT                                INITIAL ?
   FIELD TransportadoraRedespacho        AS INT                                
   FIELD ContatoPrincipal                AS CHAR                               INITIAL ?
   FIELD Regiao                          AS CHAR                               INITIAL ?
   FIELD Transportadora                  AS INT                                INITIAL ?
   FIELD ApuracaoBeneficio               AS INT                                INITIAL ?
   FIELD TipoConstituicao                AS INT                                INITIAL ?
   FIELD NumeroDiasAtraso                AS INT                                
   FIELD ClientePotencialOriginador      AS CHAR                               INITIAL ?
   FIELD CondicaoPagamento               AS INT                                INITIAL ?
   FIELD Proprietario                    AS CHAR                               INITIAL ?
   FIELD TipoProprietario                AS CHAR                               INITIAL ?
   FIELD TipoConta                       AS INT                                INITIAL ?
   FIELD CodigoCRM4                      AS CHAR                               INITIAL ?
   FIELD DataAdesao                      AS DATE                               INITIAL ?
   FIELD CodigoEstrangeiro               AS CHAR                               INITIAL ?
   FIELD OrigemConta                     AS INT  INITIAL 993520005 /*Inicializa com outros pois nao existe op‡Æopara  Origem EMS*/
   FIELD NumeroPassaporte                AS CHAR                               INITIAL ?
   FIELD StatusIntegracaoSefaz           AS INT  INITIAL 993520000 /*Inicializa como nao validado pois o EMS nao tem essa informa‡Æo*/
   FIELD DataHoraIntegracaoSefaz         AS CHAR                               INITIAL ?
   FIELD RegimeApuracao                  AS CHAR                               INITIAL ?
   FIELD DataBaixaContribuinte           AS DATE                               INITIAL ?
   FIELD AssistenciaTecnica              AS LOG                                INITIAL NO                     
   FIELD PerfilAssistenciaTecnica        AS INTEGER                            INITIAL ?                  
   FIELD TabelaPrecoAssistenciaTecnica   AS INT                                INITIAL ?                  
   FIELD NomeAbreviadoMatrizEconomica    AS CHAR                               INITIAL ?
   FIELD AtualizadoIntegracao            AS LOG                                INITIAL ?
   FIELD CodigoRamoAtividadeEconomica    LIKE int-emitente-canal.CodigoRamoAtividadeEconomica  INITIAL ?
   FIELD FiguraNoSite                    LIKE int-emitente-canal.FiguraNoSite                  
   FIELD ParticipaProgramaCanaisMotivo   LIKE int-emitente-canal.ParticipaProgramaCanaisMotivo INITIAL ?
   FIELD AdesaoPciRealizadaPor           LIKE int-emitente-canal.AdesaoPciRealizadaPor         INITIAL ?
   FIELD EscolheuDistrForaSellOut        LIKE int-emitente-canal.EscolheuDistrForaSellOut      
   FIELD DataUltimoSellOut               LIKE int-emitente-canal.DataUltimoSellOut             INITIAL ?
   FIELD Categoria                       LIKE int-emitente-canal.Categoria                     INITIAL ?
   FIELD CodigoCanalVenda                AS   INTEGER                                          INITIAL ?
   FIELD IdentificacaoConta              AS   INTEGER                                          INITIAL ?
   FIELD CodigoRepresentante             AS   INTEGER                                          INITIAL ?
   /*FIELD PossuiAcessoSolar               AS LOG
   FIELD PercentualComissaoSolar         AS DECIMAL*/
   FIELD CodigoGrupoCobranca             AS INT.

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

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

/*Defini‡Æo das temp-tables de valida‡Æo - cdp/cdapi329.p*/
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


