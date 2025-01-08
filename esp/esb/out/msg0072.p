/*********************************************************************************************************/
/* Esta mensagem tem o mesmo nome da mensagem de recebimento da conta, que est† em esp\esb\in\msg0072.p  */
/* PorÇm, s∆o programas diferentes. Este por sua vez envia os dados do Totvs para o Barramento           */
/*********************************************************************************************************/

{include/i-prgvrs.i msg0072 2.00.00.000}  /*** 010000 ***/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-emitente LIKE emitente.

{utp/ut-glob.i}
{esp/esb/out/msg0072.i}.
{esp/esb/esesb000fn2.i}


DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEFINE VARIABLE h-cdapi704 AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-rua  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-inscricaoEst AS CHARACTER FORMAT 'x(14)'  NO-UNDO.

DEFINE BUFFER b-emitente     FOR emitente.
DEFINE BUFFER b-int-emitente FOR int-emitente.

CREATE tt-emitente.
RAW-TRANSFER raw-param TO tt-emitente.

FIND FIRST emitente NO-LOCK
     WHERE emitente.cod-emitente = tt-emitente.cod-emitente NO-ERROR.

/*Definiá∆o da mensagem de envio de atualizaá∆o*/
DEFINE DATASET mensagem  XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0072, EnderecoPrincipal, EnderecoCobranca, DadosFornecedor
   DATA-RELATION FOR conteudo, msg0072          RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0072, EnderecoPrincipal RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0072, EnderecoCobranca  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0072, DadosFornecedor   RELATION-FIELDS (idm, idm) NESTED.

/*Definiá∆o e leitura da mensagem de resposta da atualizaá∆o.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0072r, resultado
   DATA-RELATION FOR conteudor, msg0072r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0072r, resultado RELATION-FIELDS (idm, idm) NESTED.
                                                   
CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0072'
       cabecalho.LoginUsuario   = c-seg-usuario
       c-inscricaoEst           = ''.
     

CREATE conteudo.
CREATE msg0072.


FOR EACH tt-emitente NO-LOCK:
    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

    FIND FIRST int-emitente-canal NO-LOCK
         WHERE int-emitente-canal.cod-emitente = emitente.cod-emitente NO-ERROR.

    FIND FIRST emitente-cex NO-LOCK
         WHERE emitente-cex.cod-emitente = emitente.cod-emitente NO-ERROR.

    FIND FIRST int-emitente-cex NO-LOCK
         WHERE int-emitente-cex.cod-emitente = emitente.cod-emitente NO-ERROR.

    FIND FIRST dist-emitente NO-LOCK
         WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

    FIND FIRST grupo-fornec NO-LOCK
         WHERE grupo-fornec.cod-gr-forn = emitente.cod-gr-forn NO-ERROR.

    FIND FIRST tipo-rec-desp NO-LOCK
         WHERE tipo-rec-desp.tp-codigo = emitente.tp-desp-padrao NO-ERROR.

    FIND FIRST inco-cx NO-LOCK
         WHERE inco-cx.cod-incoterm = emitente-cex.cod-incoterm-imp NO-ERROR.

    FIND FIRST itinerario NO-LOCK
         WHERE itinerario.cod-itiner = emitente-cex.cod-itiner-imp NO-ERROR.

    FIND FIRST pto-contr NO-LOCK
         WHERE pto-contr.cod-pto-contr = emitente-cex.cod-pto-contr NO-ERROR.

    FIND FIRST gr-cli-class-canal NO-LOCK
         WHERE gr-cli-class-canal.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.

    ASSIGN c-inscricaoEst                          = REPLACE(REPLACE(REPLACE(replace(emitente.ins-estadual,'.',''),' ',''),'-',''),'/','')
           cabecalho.NumeroOperacao                = substr(emitente.nome-emit,1,40)
           msg0072.CodigoConta                     = IF AVAIL int-emitente AND int-emitente.cod-guid <> "" THEN int-emitente.cod-guid ELSE ?
           msg0072.CodigoCliente                   = emitente.cod-emitente
           msg0072.NomeRazaoSocial                 = emitente.nome-emit
           msg0072.NomeFantasia                    = IF emitente.nom-fantasia <> "" THEN emitente.nom-fantasia ELSE emitente.nome-emit
           msg0072.NomeAbreviado                   = emitente.nome-abrev     WHEN emitente.nome-abrev    <> ""
           msg0072.NumeroBanco                     = emitente.cod-banco      
           msg0072.NumeroAgencia                   = emitente.agencia        WHEN emitente.agencia       <> ""
           msg0072.NumeroContaCorrente             = emitente.conta-corren   WHEN emitente.conta-corren  <> ""
           msg0072.EmiteBloqueto                   = emitente.emite-bloq     
           msg0072.GeraAvisoCredito                = emitente.gera-ad        
           msg0072.CalculaMulta                    = emitente.calcula-multa  
           msg0072.RecebeInformacaoSCI             = emitente.recebe-inf-sci
           msg0072.Telefone                        = emitente.telefone[1] WHEN emitente.telefone[1] <> ""
           msg0072.Ramal                           = emitente.ramal[1]    WHEN emitente.ramal[1]    <> ""
           msg0072.TelefoneAlternativo             = emitente.telefone[2] WHEN emitente.telefone[2] <> ""
           msg0072.RamalTelefoneAlternativo        = emitente.ramal[2]    WHEN emitente.ramal[2]    <> ""
           msg0072.Fax                             = emitente.telefax     WHEN emitente.telefax     <> ""
           msg0072.RamalFax                        = emitente.ramal-fax   WHEN emitente.ramal-fax   <> ""
           msg0072.Email                           = emitente.e-mail      WHEN emitente.e-mail      <> ""
           msg0072.Site                            = emitente.home-page   WHEN emitente.home-page   <> ""
           msg0072.InscricaoEstadual               = IF c-inscricaoEst  <> "" THEN c-inscricaoEst ELSE ?
           msg0072.InscricaoMunicipal              = IF emitente.ins-municipal <> "" THEN emitente.ins-municipal ELSE ?
           msg0072.ContribuinteICMS                = emitente.contrib-icms   
           msg0072.CodigoSUFRAMA                   = emitente.cod-suframa    WHEN emitente.cod-suframa  <> ""
           msg0072.InscricaoSubstituicaoTributaria = emitente.insc-subs-trib WHEN emitente.insc-subs-trib <> ""
           msg0072.OptanteSuspensaoIPI             = IF SUBSTRING(emitente.char-1, 21, 1) = "2" THEN YES ELSE NO
           msg0072.AgenteRetencao                  = emitente.agente-retencao
           msg0072.PisCofinsUnidade                = emitente.log-calcula-pis-cofins-unid
           msg0072.RecebeNotaFiscalEletronica      = emitente.log-nf-eletro
           msg0072.ObservacaoPedido                = int-emitente.observacao-ped WHEN int-emitente.observacao-ped <> "" 
           msg0072.TipoEmbalagem                   = int-emitente.tipo-embalagem WHEN int-emitente.tipo-embalagem <> ""  
           msg0072.CodigoIncoterm                  = IF AVAIL emitente-cex THEN emitente-cex.cod-incoterm-exp   ELSE ?
           msg0072.LocalEmbarque                   = IF AVAIL int-emitente-cex THEN int-emitente-cex.local-embarque ELSE ?
           msg0072.ViaEmbarque                     = IF AVAIL int-emitente-cex THEN int-emitente-cex.embarque-via   ELSE ?
           msg0072.DataImplantacao                 = IF emitente.data-implant <> ? THEN emitente.data-implant ELSE TODAY
           msg0072.DataVencimentoConcessao         = IF AVAIL int-emitente THEN int-emitente.dt-vcto-concessao ELSE ?
           msg0072.Exclusividade                   = IF AVAIL int-emitente THEN int-emitente.exclusividade     ELSE NO
           msg0072.ParticipaProgramaCanais         = IF AVAIL int-emitente AND int-emitente.ind-participa-canais <> 0 THEN int-emitente.ind-participa-canais ELSE 993520000
           msg0072.VendeAtacadista                 = IF AVAIL int-emitente AND int-emitente.ind-vendas-alc = 1 THEN YES ELSE NO
           msg0072.ObservacaoNotaFiscal            = int-emitente.dispositivo-legal WHEN int-emitente.dispositivo-legal <> ""
           msg0072.Classificacao                   = IF AVAIL int-emitente AND int-emitente.guid-class    <> "" THEN int-emitente.guid-class     ELSE IF AVAIL gr-cli-class-canal AND gr-cli-class-canal.codigo-classificacao <> "" THEN gr-cli-class-canal.codigo-classificacao ELSE "026E4C24-6BED-E311-9420-00155D013D39"
           msg0072.SubClassificacao                = IF AVAIL int-emitente AND int-emitente.guid-subclass <> "" THEN int-emitente.guid-subclass  ELSE "C6E1494F-6BED-E311-9420-00155D013D39"
           msg0072.Portador                        = IF emitente.portador <> 0 THEN emitente.portador ELSE ?
           msg0072.ReceitaPadrao                   = emitente.tp-rec-padrao
           msg0072.Regiao                          = IF AVAIL int-emitente AND int-emitente.guid-regiao <> "" THEN int-emitente.guid-regiao      ELSE ?
           msg0072.ApuracaoBeneficio               = IF AVAIL int-emitente AND int-emitente.ind-apuracao-beneficio <> 0 THEN int-emitente.ind-apuracao-beneficio ELSE 993520000
           msg0072.CondicaoPagamento               = IF emitente.cod-cond-pag <> 0 THEN emitente.cod-cond-pag ELSE ?
           msg0072.Proprietario                    = IF AVAIL int-emitente AND TRIM(int-emitente.proprietario)      <> "" THEN int-emitente.proprietario      ELSE "259a8e4f-15e9-e311-9420-00155d013d39"
           msg0072.TipoProprietario                = IF AVAIL int-emitente AND TRIM(int-emitente.tipo-proprietario) <> "" THEN int-emitente.tipo-proprietario ELSE "systemuser"
           msg0072.DataAdesao                      = IF AVAIL int-emitente THEN int-emitente.dt-adesao-canais  ELSE ?
           msg0072.NumeroPassaporte                = SUBSTRING(emitente.char-1, 103, 20) /*int-emitente-canal.NumeroPassaporte           */
           msg0072.Transportadora                  = emitente.cod-transp
           msg0072.TipoRelacao                     = 993520004
           msg0072.TipoConta                       = IF emitente.nome-abrev <> emitente.nome-matriz THEN 
                                                        993520001 /*Filial*/ 
                                                     ELSE 
                                                         993520000 /*Matriz*/.
    
    
    ASSIGN msg0072.NomeAbreviadoMatrizEconomica    = emitente.nome-matriz WHEN emitente.nome-matriz   <> ""
           msg0072.AtualizadoIntegracao            = IF AVAIL int-emitente-canal THEN NOT(int-emitente-canal.IntegraTrigger) ELSE NO.
    
    IF int-emitente.id-ativo OR (AVAIL dist-emitente AND dist-emitente.idi-sit-fornec = 1) THEN
        ASSIGN msg0072.Situacao = 0.
    ELSE 
        ASSIGN msg0072.Situacao = 1.

    RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
    RUN pi-trata-endereco IN h-cdapi704 (INPUT  emitente.endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).

    CREATE EnderecoPrincipal.
    ASSIGN EnderecoPrincipal.CEP         = IF emitente.cep <> "" THEN TRIM(emitente.cep) ELSE "00000000"
           EnderecoPrincipal.Logradouro  = IF AVAIL int-emitente AND trim(substring(int-emitente.logradouro,1,35))  <> "" THEN trim(substring(int-emitente.logradouro,1,35))  ELSE trim(substring(c-rua,1,35))
           EnderecoPrincipal.Numero      = IF AVAIL int-emitente AND int-emitente.numero      <> "" THEN int-emitente.numero      ELSE trim(substring(c-nro,1,5))
           EnderecoPrincipal.Complemento = IF AVAIL int-emitente AND int-emitente.complemento <> "" THEN int-emitente.complemento ELSE IF trim(substring(c-comp,1,40)) <> "" THEN trim(substring(c-comp,1,40)) ELSE ?
           EnderecoPrincipal.Bairro      = trim(emitente.bairro)                 
           EnderecoPrincipal.NomeCidade  = trim(emitente.cidade) 
           EnderecoPrincipal.Cidade      = trim(emitente.cidade) + "," + trim(emitente.estado) + "," + trim(emitente.pais)                        
           EnderecoPrincipal.UF          = IF emitente.estado <> "" THEN trim(emitente.estado) ELSE "EX"
           EnderecoPrincipal.Estado      = trim(emitente.pais) + "," + trim(emitente.estado) 
           EnderecoPrincipal.NomePais    = trim(emitente.pais).

    IF  emitente.cep-cob    <> ""
    AND emitente.estado-cob <> "" THEN DO:

        RUN pi-trata-endereco IN h-cdapi704 (INPUT  emitente.endereco-cob,
                                             OUTPUT c-rua, 
                                             OUTPUT c-nro, 
                                             OUTPUT c-comp).
        
        /*Chamado 88043, se for somente fornecedor n∆o enviar endereáo de cobranáa*/
        IF emitente.identific <> 2 THEN DO:
            CREATE EnderecoCobranca.
            ASSIGN EnderecoCobranca.CEP         = IF emitente.cep-cob <> "" THEN TRIM(emitente.cep-cob) ELSE "00000000"                                 
                   EnderecoCobranca.Logradouro  = IF AVAIL int-emitente AND trim(substring(int-emitente.logradouro-cob,1,35))  <> "" THEN trim(substring(int-emitente.logradouro-cob,1,35))  ELSE trim(substring(c-rua,1,35))                                    
                   EnderecoCobranca.Numero      = IF AVAIL int-emitente AND int-emitente.numero-cob      <> "" THEN int-emitente.numero-cob      ELSE trim(substring(c-nro,1,5))                                     
                   EnderecoCobranca.Complemento = IF AVAIL int-emitente AND int-emitente.complemento-cob <> "" THEN int-emitente.complemento-cob ELSE IF trim(substring(c-comp,1,40)) <> "" THEN trim(substring(c-comp,1,40)) ELSE ?                                  
                   EnderecoCobranca.Bairro      = trim(emitente.bairro-cob)                               
                   EnderecoCobranca.NomeCidade  = trim(emitente.cidade-cob)                               
                   EnderecoCobranca.Cidade      = trim(emitente.cidade-cob) + "," + trim(emitente.estado-cob) + "," + trim(emitente.pais-cob)                        
                   EnderecoCobranca.UF          = IF emitente.estado-cob <> "" THEN trim(emitente.estado-cob) ELSE "EX"                                  
                   EnderecoCobranca.Estado      = trim(emitente.pais-cob) + "," + trim(emitente.estado-cob)                                  
                   EnderecoCobranca.NomePais    = trim(emitente.pais-cob). 
        END.
    END.

    DELETE PROCEDURE h-cdapi704.
    ASSIGN h-cdapi704 = ?.

    IF  AVAIL int-emitente
    AND int-emitente.ind-participa-portal-fornec > 0
    AND emitente.identific >= 2 THEN DO:
            
            CREATE DadosFornecedor.
            ASSIGN DadosFornecedor.TaxaFinanceira              = emitente.taxa-financ   
                   DadosFornecedor.SituacaoCompras             = IF AVAIL dist-emitente THEN dist-emitente.idi-sit-fornec ELSE 1
                   DadosFornecedor.CodigoGrupoFornecedores     = emitente.cod-gr-forn 
                   DadosFornecedor.DescricaoGrupoFornecedores  = IF AVAIL grupo-fornec THEN grupo-fornec.descricao ELSE ""
                   DadosFornecedor.Observacoes                 = emitente.observacoes
                   DadosFornecedor.NomeMatriz                  = emitente.nome-matriz             
                   DadosFornecedor.DiasTaxaFinanceira          = emitente.nr-dias-taxa            
                   DadosFornecedor.CodigoTipoDespesaPadrao     = emitente.tp-desp-padrao          
                   DadosFornecedor.DescricaoTipoDespesaPadrao  = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ""         
                   DadosFornecedor.CodigoTipoPagamento         = emitente.tp-pagto                
                   DadosFornecedor.TributacaoCOFINS            = emitente.idi-tributac-cofins     
                   DadosFornecedor.TributacaoPIS               = emitente.idi-tributac-pis        
                   DadosFornecedor.FornecedorEmiteNFECTE       = emitente.log-possui-nf-eletro    
                   DadosFornecedor.Forecasting                 = IF AVAIL int-emitente THEN int-emitente.forecasting   ELSE NO         
                   DadosFornecedor.MesesForecast               = IF AVAIL int-emitente THEN int-emitente.meses-forcast ELSE 0      
                   DadosFornecedor.DataUltimaAtualizacao       = IF AVAIL int-emitente THEN int-emitente.dt-ult-atualizacao ELSE ?
                   DadosFornecedor.CodigoABA                   = IF AVAIL emitente-cex THEN emitente-cex.cod-aba ELSE ""             
                   DadosFornecedor.CodigoItinerario            = IF AVAIL emitente-cex THEN emitente-cex.cod-itiner-imp ELSE 0
                   DadosFornecedor.DescricaoItinerario         = IF AVAIL itinerario   THEN itinerario.descricao ELSE ""            
                   DadosFornecedor.CodigoIncoterm              = IF AVAIL emitente-cex THEN emitente-cex.cod-incoterm-imp ELSE ""    
                   DadosFornecedor.DescricaoIncoterm           = IF AVAIL inco-cx      THEN inco-cx.descricao ELSE ""
                   DadosFornecedor.CodigoPontoControleBase     = IF AVAIL emitente-cex THEN emitente-cex.cod-pto-contr ELSE 0
                   DadosFornecedor.DescricaoPontoControleBase  = IF AVAIL pto-contr    THEN pto-contr.descricao ELSE ""
                   DadosFornecedor.CodigoDespachante           = IF AVAIL emitente-cex THEN emitente-cex.cdn-despa-import ELSE 0          
                   DadosFornecedor.CodigoDespachanteExterior   = IF AVAIL emitente-cex THEN emitente-cex.cdn-despa-exter-import ELSE 0    
                   DadosFornecedor.CodigoSeguradora            = IF AVAIL emitente-cex THEN emitente-cex.cdn-segurad-import ELSE 0       
                   DadosFornecedor.CodigoCorretorCambio        = IF AVAIL emitente-cex THEN emitente-cex.cdn-corretor-cambio-import ELSE 0
                   DadosFornecedor.CodigoCorretorSeguro        = IF AVAIL emitente-cex THEN emitente-cex.cdn-corretor-import ELSE 0
                   DadosFornecedor.Fornecimento                = SUBSTRING(emitente.char-2,104,8) 
                   DadosFornecedor.Cooperativa                 = IF SUBSTRING(emitente.char-2,103,1) = "S" THEN YES ELSE NO
                   DadosFornecedor.AssociacaoDesportiva        = IF SUBSTRING(emitente.char-2,112,1) = "S" THEN YES ELSE NO
                   DadosFornecedor.AtivoFornecedor             = IF AVAIL dist-emitente THEN 
                                                                     IF dist-emitente.idi-sit-fornec = 1 THEN 
                                                                         YES 
                                                                     ELSE 
                                                                         NO 
                                                                 ELSE 
                                                                     NO.

        RUN RetiraAcentos (INPUT-OUTPUT DadosFornecedor.Observacoes).
                    
        IF AVAIL int-emitente THEN    
            ASSIGN DadosFornecedor.ParticipaPortalFornecedores = int-emitente.ind-participa-portal-fornec.
    END.
    
    IF AVAIL int-emitente-canal THEN DO:        

        ASSIGN msg0072.ContaPrimaria                  = IF int-emitente-canal.guid-matriz <> "" AND int-emitente-canal.guid-matriz <> int-emitente.cod-guid THEN int-emitente-canal.guid-matriz ELSE ? /*N∆o deve enviar o guid matriz quando ele mesmo Ç a matriz*/
               msg0072.DescricaoConta                 = int-emitente-canal.DescricaoConta WHEN int-emitente-canal.DescricaoConta <> ""
               msg0072.TipoRelacao                    = IF int-emitente-canal.TipoRelacao > 0 THEN int-emitente-canal.TipoRelacao ELSE 993520004 /*Acordado com o JosÇ, se tem origem no EMS Ç sempre fornecedor*/
               msg0072.SuspensaoCredito               = int-emitente-canal.SuspensaoCredito               
               msg0072.LimiteCredito                  = emitente.lim-credito
               msg0072.DataLimiteCredito              = emitente.dt-lim-cred
               msg0072.SaldoCredito                   = int-emitente-canal.SaldoCredito
               msg0072.RG                             = int-emitente-canal.RG                              WHEN int-emitente-canal.RG                            <> "" 
               msg0072.OrgaoExpeditor                 = int-emitente-canal.OrgaoExpeditor                  WHEN int-emitente-canal.OrgaoExpeditor                <> ""
               msg0072.DescontoAssistenciaTecnica     = int-emitente-canal.DescontoAssistenciaTecnica      
               msg0072.CoberturaGeografica            = int-emitente-canal.CoberturaGeografica             WHEN int-emitente-canal.CoberturaGeografica           <> "" 
               msg0072.DataConstituicao               = int-emitente-canal.DataConstituicao               
               msg0072.DistribuicaoUnicaFonteReceita  = int-emitente-canal.DistribuicaoUnicaFonteReceita   
               msg0072.DistribuidorPrincipal          = int-emitente-canal.DistribuidorPrincipal           WHEN int-emitente-canal.DistribuidorPrincipal         <> ""  
               msg0072.QualificadoTreinamento         = int-emitente-canal.QualificadoTreinamento          WHEN int-emitente-canal.QualificadoTreinamento        <> ""  
               msg0072.Historico                      = int-emitente-canal.Historico                       WHEN int-emitente-canal.Historico                     <> ""  
               msg0072.IntencaoApoio                  = int-emitente-canal.IntencaoApoio                   WHEN int-emitente-canal.IntencaoApoio                 <> ""  
               msg0072.MetodoComercializacao          = int-emitente-canal.MetodoComercializacao           WHEN int-emitente-canal.MetodoComercializacao         <> ""  
               msg0072.ModeloOperacao                 = int-emitente-canal.ModeloOperacao                  WHEN int-emitente-canal.ModeloOperacao                <> ""  
               msg0072.NumeroFuncionarios             = int-emitente-canal.NumeroFuncionarios              
               msg0072.NumeroColaboradoresAreaTecnica = int-emitente-canal.NumeroColaboradoresAreaTecn     
               msg0072.NumeroRevendasAtivas           = int-emitente-canal.NumeroRevendasAtivas            
               msg0072.NumeroRevendasInativas         = int-emitente-canal.NumeroRevendasInativas         
               msg0072.NumeroTecnicosSuporte          = int-emitente-canal.NumeroTecnicosSuporte          
               msg0072.NumeroVendedores               = int-emitente-canal.NumeroVendedores               
               msg0072.OutraFonteReceita              = int-emitente-canal.OutraFonteReceita               WHEN int-emitente-canal.OutraFonteReceita             <> ""  
               msg0072.PerfilRevendasDistribuidor     = int-emitente-canal.PerfilRevendasDistribuidor      WHEN int-emitente-canal.PerfilRevendasDistribuidor    <> ""  
               msg0072.PossuiEstruturaCompleta        = int-emitente-canal.PossuiEstruturaCompleta         
               msg0072.PossuiFiliais                  = int-emitente-canal.PossuiFiliais                  
               msg0072.QuantidadeFiliais              = int-emitente-canal.QuantidadeFiliais              
               msg0072.PrazoMedioCompra               = int-emitente-canal.PrazoMedioCompra                
               msg0072.PrazoMedioVenda                = int-emitente-canal.PrazoMedioVenda                
               msg0072.Setor                          = IF int-emitente-canal.Setor <> 0 THEN int-emitente-canal.Setor ELSE ?
               msg0072.RamoAtividadeEconomica         = int-emitente-canal.RamoAtividadeEconomica          WHEN int-emitente-canal.RamoAtividadeEconomica        <> ""  
               msg0072.SistemaGestao                  = int-emitente-canal.SistemaGestao                   WHEN int-emitente-canal.SistemaGestao                 <> ""  
               msg0072.ValorMedioCompra               = int-emitente-canal.ValorMedioCompra               
               msg0072.ValorMedioVenda                = int-emitente-canal.ValorMedioVenda                
               msg0072.ListaPreco                     = int-emitente-canal.ListaPreco                      WHEN int-emitente-canal.ListaPreco                    <> ""  
               msg0072.EstruturaPropriedade           = IF int-emitente-canal.EstruturaPropriedade <> 0 THEN int-emitente-canal.EstruturaPropriedade ELSE ?
               msg0072.ReceitaAnual                   = int-emitente-canal.ReceitaAnual                   
               msg0072.CNAE                           = int-emitente-canal.CNAE                            WHEN int-emitente-canal.CNAE                          <> ""  
               msg0072.NivelPosVenda                  = int-emitente-canal.NivelPosVenda                   WHEN int-emitente-canal.NivelPosVenda                 <> ""  
               msg0072.TransportadoraRedespacho       = IF int-emitente-canal.TransportadoraRedespacho <> 0 THEN int-emitente-canal.TransportadoraRedespacho ELSE ?
               msg0072.ContatoPrincipal               = IF int-emitente-canal.ContatoPrincipal <> "" THEN int-emitente-canal.ContatoPrincipal ELSE ?
               msg0072.NumeroDiasAtraso               = int-emitente-canal.NumeroDiasAtraso           
               msg0072.ClientePotencialOriginador     = IF int-emitente-canal.ClientePotencialOriginador <> "" THEN int-emitente-canal.ClientePotencialOriginador ELSE ?
               msg0072.TipoConta                      = IF int-emitente-canal.TipoConta > 0 THEN 
                                                             int-emitente-canal.TipoConta 
                                                        ELSE
                                                             IF emitente.nome-abrev <> emitente.nome-matriz THEN 
                                                                 993520001 /*Filial*/ 
                                                             ELSE 993520000 /*Matriz*/
               msg0072.OrigemConta                    = int-emitente-canal.OrigemConta                    
               msg0072.StatusIntegracaoSefaz          = int-emitente-canal.StatusIntegracaoSefaz           
               msg0072.DataHoraIntegracaoSefaz        = IF fnConvDatetimeChar(int-emitente-canal.DataHoraIntegracaoSefaz) <> "" THEN fnConvDatetimeChar(int-emitente-canal.DataHoraIntegracaoSefaz) ELSE ?
               msg0072.RegimeApuracao                 = int-emitente-canal.RegimeApuracao                 WHEN int-emitente-canal.RegimeApuracao <> ""  
               msg0072.DataBaixaContribuinte          = int-emitente-canal.DataBaixaContribuinte
               msg0072.CodigoCRM4                     = IF int-emitente-canal.CodigoCRM4 <> "" THEN int-emitente-canal.CodigoCRM4 ELSE ?
               msg0072.AssistenciaTecnica             = IF int-emitente-canal.AssistenciaTecnica            = ? THEN NO ELSE int-emitente-canal.AssistenciaTecnica
               msg0072.PerfilAssistenciaTecnica       = if int-emitente-canal.PerfilAssistenciaTecnica      = 0 then ?  else int-emitente-canal.PerfilAssistenciaTecnica
               msg0072.TabelaPrecoAssistenciaTecnica  = if int-emitente-canal.TabelaPrecoAssistenciaTecnica = 0 then ?  else int-emitente-canal.TabelaPrecoAssistenciaTecnica
               msg0072.CodigoRamoAtividadeEconomica   = IF int-emitente-canal.CodigoRamoAtividadeEconomica  <> "" THEN int-emitente-canal.CodigoRamoAtividadeEconomica ELSE ?
               msg0072.FiguraNoSite                   = int-emitente-canal.FiguraNoSite                   
               msg0072.ParticipaProgramaCanaisMotivo  = IF int-emitente-canal.ParticipaProgramaCanaisMotivo <> 0 THEN int-emitente-canal.ParticipaProgramaCanaisMotivo ELSE ?
               msg0072.AdesaoPciRealizadaPor          = int-emitente-canal.AdesaoPciRealizadaPor          WHEN int-emitente-canal.AdesaoPciRealizadaPor <> "" 
               msg0072.EscolheuDistrForaSellOut       = int-emitente-canal.EscolheuDistrForaSellOut       
               msg0072.DataUltimoSellOut              = int-emitente-canal.DataUltimoSellOut              
               msg0072.Categoria                      = IF int-emitente-canal.Categoria <> "" THEN int-emitente-canal.Categoria ELSE ?.

        
        ASSIGN EnderecoPrincipal.NomeEndereco = int-emitente-canal.NomeEndereco WHEN int-emitente-canal.NomeEndereco  <> ""
               EnderecoPrincipal.TipoEndereco = int-emitente-canal.TipoEndereco 
               EnderecoPrincipal.CaixaPostal  = int-emitente-canal.CaixaPostal  WHEN int-emitente-canal.CaixaPostal   <> ""            
               EnderecoPrincipal.Estado       = int-emitente-canal.Estado       WHEN int-emitente-canal.Estado        <> ""                         
               EnderecoPrincipal.Pais         = int-emitente-canal.Pais         WHEN int-emitente-canal.Pais          <> ""                         
               EnderecoPrincipal.NomeContato  = int-emitente-canal.NomeContato  WHEN int-emitente-canal.NomeContato   <> ""                         
               EnderecoPrincipal.Telefone     = int-emitente-canal.Telefone     WHEN int-emitente-canal.Telefone      <> ""        
               EnderecoPrincipal.Fax          = int-emitente-canal.Fax          WHEN int-emitente-canal.Fax           <> "".

        IF emitente.identific <> 2 THEN DO:
            ASSIGN EnderecoCobranca.NomeEndereco = int-emitente-canal.NomeEnderecoCob WHEN int-emitente-canal.NomeEnderecoCob  <> ""                          
                   EnderecoCobranca.TipoEndereco = int-emitente-canal.TipoEnderecoCob
                   EnderecoCobranca.CaixaPostal  = int-emitente-canal.CaixaPostalCob  WHEN int-emitente-canal.CaixaPostalCob   <> ""                            
                   EnderecoCobranca.Estado       = int-emitente-canal.EstadoCob       WHEN int-emitente-canal.EstadoCob        <> ""                      
                   EnderecoCobranca.Pais         = int-emitente-canal.PaisCob         WHEN int-emitente-canal.PaisCob          <> ""                                
                   EnderecoCobranca.NomeContato  = int-emitente-canal.NomeContatoCob  WHEN int-emitente-canal.NomeContatoCob   <> ""                               
                   EnderecoCobranca.Telefone     = int-emitente-canal.TelefoneCob     WHEN int-emitente-canal.TelefoneCob      <> ""                               
                   EnderecoCobranca.Fax          = int-emitente-canal.FaxCob          WHEN int-emitente-canal.FaxCob           <> "".
        END.

        RUN RetiraAcentos (INPUT-OUTPUT msg0072.DescricaoConta).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.ObservacaoPedido).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.TipoEmbalagem ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.LocalEmbarque ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.ViaEmbarque ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.CoberturaGeografica ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.Historico ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.IntencaoApoio).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.MetodoComercializacao ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.ModeloOperacao  ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.OutraFonteReceita  ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.PerfilRevendasDistribuidor  ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.ObservacaoNotaFiscal   ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.PerfilRevendasDistribuidor  ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.PerfilRevendasDistribuidor  ).
        RUN RetiraAcentos (INPUT-OUTPUT msg0072.RamoAtividadeEconomica).

    END. /* AVAIL int-emitente-canal */

    IF AVAIL emitente THEN DO:
       IF emitente.identific <> 2 THEN 
          ASSIGN EnderecoPrincipal.Estado  = trim(emitente.pais)     + "," + trim(emitente.estado) 
                 EnderecoCobranca.Estado   = trim(emitente.pais-cob) + "," + trim(emitente.estado-cob).                                  
    END.
    
    /*Chamado 98377*/
    IF emitente.cod-gr-cli = 6  THEN
        ASSIGN msg0072.OrigemConta = 993520006.

    IF  msg0072.AssistenciaTecnica = ? THEN msg0072.AssistenciaTecnica = NO.
    
    CASE emitente.modalidade:
        WHEN 1 THEN
            ASSIGN msg0072.ModalidadeCobranca = 993520000.
        WHEN 2 THEN
            ASSIGN msg0072.ModalidadeCobranca = 993520001.
        WHEN 3 THEN
            ASSIGN msg0072.ModalidadeCobranca = 993520002.
        WHEN 4 THEN
            ASSIGN msg0072.ModalidadeCobranca = 993520003.
        WHEN 5 THEN
            ASSIGN msg0072.ModalidadeCobranca = 993520004.
        WHEN 6 THEN
            ASSIGN msg0072.ModalidadeCobranca = 993520005.
        WHEN 7 THEN
            ASSIGN msg0072.ModalidadeCobranca = 993520006.
        WHEN 8 THEN
            ASSIGN msg0072.ModalidadeCobranca = 993520007.
        WHEN 9 THEN
            ASSIGN msg0072.ModalidadeCobranca = 993520008.
        OTHERWISE 
            ASSIGN msg0072.ModalidadeCobranca = 993520009.
    END CASE.

    CASE emitente.natureza:
        WHEN 1 THEN
            ASSIGN msg0072.Natureza = 993520003
                   msg0072.CPF = emitente.cgc
                   msg0072.TipoConstituicao = 993520000.
        WHEN 2 THEN
            ASSIGN msg0072.Natureza = 993520000
                   msg0072.CNPJ = emitente.cgc
                   msg0072.TipoConstituicao = 993520001.
        WHEN 3 THEN
            ASSIGN msg0072.Natureza = 993520001
                   msg0072.CodigoEstrangeiro = emitente.cgc
                   msg0072.TipoConstituicao = 993520002.
        OTHERWISE
            ASSIGN msg0072.Natureza = 993520002
                   msg0072.CNPJ = emitente.cgc
                   msg0072.TipoConstituicao = 993520001.
    END CASE.

    CASE int-emitente.ind-forma-tributo:
        WHEN 1 THEN /*Lucro Real*/
            ASSIGN msg0072.FormaTributacao = 993520000.
        WHEN 2 THEN /*Lucro Presumido*/
            ASSIGN msg0072.FormaTributacao = 993520001.
        WHEN 3 THEN /*Simples*/
            ASSIGN msg0072.FormaTributacao = 993520002.
        WHEN 5 THEN /*Isento*/
            ASSIGN msg0072.FormaTributacao = 993520004.         
        OTHERWISE /* Nenhum */
            ASSIGN msg0072.FormaTributacao = 993520003.
    END CASE.
        
    ASSIGN msg0072.CodigoCanalVenda    = emitente.cod-canal-venda
           msg0072.IdentificacaoConta  = IF  emitente.identific  = 1 THEN 993520000
                                         ELSE IF emitente.identific  = 2 THEN 993520001
                                              ELSE 993520002
           msg0072.CodigoRepresentante = IF  emitente.cod-rep > 0 THEN emitente.cod-rep ELSE ?.
        
END.


/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}


FIND FIRST resultado NO-ERROR.

IF  AVAIL resultado
AND resultado.Sucesso THEN DO:
    FIND FIRST msg0072r NO-ERROR.

    IF AVAIL msg0072r THEN DO:
        FIND FIRST int-emitente EXCLUSIVE-LOCK
             WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

        IF AVAIL int-emitente THEN DO:            
            ASSIGN int-emitente.proprietario      = msg0072r.Proprietario
                   int-emitente.tipo-proprietario = msg0072r.TipoProprietario
                   int-emitente.cod-guid          = msg0072r.CodigoConta.
        END.
    
        FIND CURRENT int-emitente NO-LOCK NO-ERROR.
    END.
END.

RETURN.
PROCEDURE RetiraAcentos:

    DEF INPUT-OUTPUT PARAMETER c-texto AS CHAR.
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-caracter AS CHARACTER   NO-UNDO.
    

    DO i-cont = 1 TO LENGTH(c-texto):
        ASSIGN c-caracter = SUBSTRING(c-texto,i-cont,1).
        CASE trim(c-caracter):
           when "a" THEN next.
           when "b" THEN next.
           when "c" THEN next.
           when "d" THEN next.
           when "e" THEN next.
           when "f" THEN next.
           when "g" THEN next.
           when "h" THEN next.
           when "i" THEN next.
           when "j" THEN next.
           when "k" THEN next.
           when "l" THEN next.
           when "m" THEN next.
           when "n" THEN next.
           when "o" THEN next.
           when "p" THEN next.
           when "q" THEN next.
           when "r" THEN next.
           when "s" THEN next.
           when "t" THEN next.
           when "u" THEN next.
           when "v" THEN next.
           when "w" THEN next.
           when "x" THEN next.
           when "y" THEN next.
           when "z" THEN next.
           when " " THEN next.
           when "0" THEN next.
           when "1" THEN next.
           when "2" THEN next.
           when "3" THEN next.
           when "4" THEN next.
           when "5" THEN next.
           when "6" THEN next.
           when "7" THEN next.
           when "8" THEN next.
           when '9' THEN next.
           when '"' THEN next.
           when "'" THEN next.
           when "!" THEN next.
           when "[" THEN next.
           when "]" THEN next.
           when "@" THEN next.
           when "#" THEN next.
           when "$" THEN next.
           when "%" THEN next.
           when "&" THEN next.
           when "*" THEN next.
           when "(" THEN next.
           when ")" THEN next.
           when "-" THEN next.
           when "_" THEN next.
           when "=" THEN next.
           when "+" THEN next.
           when "<" THEN next.
           when ">" THEN next.
           when "," THEN next.
           when "." THEN next.
           when ":" THEN next.
           when ";" THEN next.
           when "?" THEN next.
           when "/" THEN next.
           when "~\" THEN next.
           when "«" THEN next.
           when "á" THEN next.
           when "†" THEN next.
           when "∆" THEN next.
           when "É" THEN next.
           when "Ö" THEN next.
           when "Ç" THEN next.
           when "ä" THEN next.
           when "à" THEN next.
           when "¢" THEN next.
           when "°" THEN next.
           when "å" THEN next.
           when "ç" THEN next.
           when "ï" THEN next.
           when "‰" THEN next.
           when "ì" THEN next.
           when "£" THEN next.
           when "ó" THEN next.

           OTHERWISE ASSIGN OVERLAY(c-texto,i-cont,1) = "".
       END.
    END.



END PROCEDURE.




