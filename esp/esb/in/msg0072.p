CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEFINE BUFFER b-emitente            FOR emitente.
DEFINE BUFFER b-int-emit-Matriz-crm FOR int-emitente.
IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE("inicio msg0072").
{esp/esb/in/msg0072.i}
/* Inicio criar pedido execucao */
{btb/btb912zb.i}
{esp/es0018.i}

DEF VAR p-prox-emitente         AS INT                       NO-UNDO.
DEF VAR c-programa-mg97         AS CHAR                      NO-UNDO.
DEF VAR c-versao-mg97           AS CHAR                      NO-UNDO.
DEF VAR i-cont-aux              AS INT                       NO-UNDO.
DEF VAR p_cod_prog_dtsul_w      AS CHAR  FORMAT "x(50)"      NO-UNDO.
DEF VAR p_cod_prog_dtsul_rp     AS CHAR  FORMAT "x(50)"      NO-UNDO.
DEF VAR p_cod_release           AS CHAR  FORMAT "x(9)"       NO-UNDO.
DEF VAR p_cdn_estil_dwb         AS INT   FORMAT ">>9"        NO-UNDO.
DEF VAR p_arquivo               AS CHAR  FORMAT "x(50)"      NO-UNDO.
DEF VAR p_destino               AS INT   FORMAT "9"          NO-UNDO.
DEF VAR p_raw_param             AS RAW                       NO-UNDO.
DEF VAR p_num_ped_exec          AS INT   FORMAT ">>>>9"      NO-UNDO.
DEF VAR v-log-agenda-auto-ok    AS LOG   INIT YES            NO-UNDO.
DEF VAR v_num_aux               AS INT   FORMAT ">>>>,>>9"   NO-UNDO.
DEF VAR v_dat_exec_ped_exec_old AS DATE  FORMAT "99/99/9999" LABEL "Data Execuá∆o"   COLUMN-LABEL "Data Exec" NO-UNDO.
DEF VAR v_hra_exec_ped_exec_old AS CHAR  FORMAT "99:99:99"   LABEL "Hora Execuá∆o"   COLUMN-LABEL "Hora Exec" NO-UNDO.
DEF VAR v_log_answer            AS LOG                       NO-UNDO.
DEF VAR v_cod_msg_parameters    AS CHAR  FORMAT "x(2000)"    NO-UNDO.
DEF VAR v_cod_prog_dtsul        AS CHAR  FORMAT "x(50)"      LABEL "Programa"        COLUMN-LABEL "Programa"  NO-UNDO.
DEF VAR v_num_msg_erro          AS INT   FORMAT ">>>>>>9"    LABEL "Mensagem"        COLUMN-LABEL "Mensagem"  NO-UNDO.
DEF VAR v_cdn_empresa_aux       LIKE mgcad.empresa.ep-codigo NO-UNDO.
DEF VAR c-prmgems               AS CHAR                      NO-UNDO.   
DEF VAR  i-forma-tributo-antiga AS INT                       NO-UNDO.
DEF VAR v_log_grupo_cob         AS LOG                       NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-autconlist               AS LOG                      NO-UNDO.    
DEF NEW GLOBAL SHARED VAR v_rec_ped_exec             AS RECID   FORMAT ">>>>>>9" NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_aplicat_dtsul_corren AS CHAR    FORMAT "x(3)"    NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_modul_dtsul_empres   AS CHAR    FORMAT "x(100)"  NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_funcao_negoc_empres  AS CHAR    FORMAT "x(50)"   NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_modul_dtsul_corren   AS CHAR    FORMAT "x(3)"    LABEL "M¢dulo Corrente" COLUMN-LABEL "M¢dulo Corrente" NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_ccusto_corren        AS CHAR    FORMAT "x(11)"   LABEL "Centro Custo"    COLUMN-LABEL "Centro Custo" NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_unid_negoc_usuar     AS CHAR    FORMAT "x(3)"    VIEW-AS COMBO-BOX LIST-ITEMS "" INNER-LINES 5 BGCOLOR 15 FONT 2 LABEL "Unidade Neg¢cio" column-label "Unid Neg¢cio" NO-UNDO.

DEF VAR l-novo-emitente AS LOG INIT NO NO-UNDO.
/* fim criar pedido execucao */
  
DEF VAR i-ind           AS INT         NO-UNDO.

DEFINE VAR h-prx073 AS HANDLE NO-UNDO.

/* temptables pac-versao-mg97  ra chamar esb0000 */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino         AS INTEGER
    FIELD arquivo         AS CHAR FORMAT "x(35)"
    FIELD usuario         AS CHAR FORMAT "x(12)"
    FIELD data-exec       AS DATE
    FIELD hora-exec       AS INTEGER
    FIELD classifica      AS INTEGER
    FIELD desc-classifica AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf      AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf   AS LOG
    FIELD ind-execucao    AS INT
    FIELD cod-emitente    AS INT.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9"
    FIELD exemplo AS CHARACTER FORMAT "x(30)"
    INDEX id ordem.

DEFINE BUFFER b-tt-digita FOR tt-digita.

/* Transfer Definitions */

DEFINE VARIABLE raw-param  AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.

/* fim temptables para chamar esb0000 */

DEFINE DATASET mensagem  XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0072, EnderecoPrincipal, EnderecoCobranca
   DATA-RELATION FOR conteudo, msg0072          RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0072, EnderecoPrincipal RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0072, EnderecoCobranca  RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0072r, resultado
   DATA-RELATION FOR conteudor, msg0072r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0072r, resultado RELATION-FIELDS (idm, idm) NESTED.

FIND msg0072           NO-ERROR.
FIND EnderecoPrincipal NO-ERROR.
FIND EnderecoCobranca  NO-ERROR.




blk_principal:
DO TRANSACTION
ON ERROR UNDO blk_principal,LEAVE blk_principal
ON STOP  UNDO blk_principal,LEAVE blk_principal:

    ERROR-STATUS:ERROR = NO.

    RUN pi-verifica-registro.

    IF INDEX(msg0072.NomeRazaoSocial,CHR(150)) > 0 THEN 
        RUN pi-valida-caracter(INPUT 1).

    IF INDEX(msg0072.NomeFantasia,CHR(150)) > 0 THEN
       RUN pi-valida-caracter(INPUT 2).

    IF msg0072.CodigoCliente = 0 THEN
        ASSIGN msg0072.CodigoCliente = ?.

    IF msg0072.ContaPrimaria = "" THEN
        ASSIGN msg0072.ContaPrimaria = ?.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = msg0072.CodigoCliente NO-ERROR.

    IF NOT AVAIL emitente THEN DO:
        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-guid = msg0072.CodigoConta NO-ERROR.

        IF AVAIL int-emitente THEN DO:
            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = int-emitente.cod-emitente NO-ERROR.
        END.

        IF NOT AVAIL emitente THEN DO:
            IF msg0072.Natureza = 993520003 THEN
                FIND FIRST emitente EXCLUSIVE-LOCK
                     WHERE emitente.cgc = msg0072.CPF NO-ERROR.
        
            ELSE IF msg0072.Natureza = 993520000 THEN
                 FIND FIRST emitente EXCLUSIVE-LOCK
                      WHERE emitente.cgc = msg0072.CNPJ NO-ERROR.

            ELSE IF msg0072.Natureza = 993520001 THEN
                FIND FIRST emitente EXCLUSIVE-LOCK
                      WHERE emitente.cgc = msg0072.CodigoEstrangeiro NO-ERROR.
        END.
    END.
          
    IF NOT AVAIL emitente THEN DO:

        FIND LAST emitente NO-LOCK NO-ERROR.
        IF AVAILABLE emitente THEN DO:
            run cdp/cd9960.p (OUTPUT p-prox-emitente).
        END.
        ELSE
            ASSIGN p-prox-emitente = 0.

        CREATE tt-cliente-valid.
        ASSIGN tt-cliente-valid.cod-emitente   = p-prox-emitente
               tt-cliente-valid.ind-tipo-movto = 1
               tt-cliente-valid.identific      = /*1*/ 3 /*Sempre tem que ser ambos por causa do pagamento a forn. no finaceiro*/
               tt-cliente-valid.cod-gr-forn    = 3 /*acordado com o financeiro e Fabiano FIXAR grupo de cliente como 3 */ 
               tt-cliente-valid.tp-desp-padrao = 8 /*acordado com o financeiro e Fabiano FIXAR tipo de despesa padr∆o como 8 */ . 

        CREATE int-emitente.
        ASSIGN int-emitente.cod-emitente = p-prox-emitente.

        CREATE emitente-cex.
        ASSIGN emitente-cex.cod-emite = p-prox-emitente.

        CREATE int-emitente-cex.
        ASSIGN int-emitente-cex.cod-emitente = p-prox-emitente.

        IF msg0072.Natureza = 993520003 THEN
            ASSIGN tt-cliente-valid.natureza = 1
                   tt-cliente-valid.nome-abrev = TRIM(msg0072.NomeAbreviado). /*TRIM(SUBSTRING(msg0072.CPF,1,12)).*/
        ELSE IF msg0072.Natureza = 993520000 THEN
            ASSIGN tt-cliente-valid.natureza = 2
                   tt-cliente-valid.nome-abrev = TRIM(msg0072.NomeAbreviado).
        ELSE
            ASSIGN tt-cliente-valid.natureza = 3
                   tt-cliente-valid.nome-abrev = TRIM(SUBSTRING(msg0072.CodigoEstrangeiro,1,12)).

        CREATE int-emitente-canal.
        ASSIGN int-emitente-canal.cod-emitente = int-emitente.cod-emitente.

        /*Indica que n∆o existe ainda no EMS*/
        ASSIGN l-novo-emitente = YES.

    END.
    ELSE DO:
        CREATE tt-cliente-valid.
        BUFFER-COPY emitente TO tt-cliente-valid.
/*         IF emitente.identific = 2 THEN             */
/*             ASSIGN tt-cliente-valid.identific = 3. */
/*                                                    */
        IF emitente.identific < 3 THEN
            ASSIGN tt-cliente-valid.identific = 3.

        IF  emitente.identific = 1 THEN 
            ASSIGN tt-cliente-valid.cod-gr-forn    = 3 /* Acordado com o financeiro e Fabiano FIXAR grupo de cliente como 3 */ 
                   tt-cliente-valid.tp-desp-padrao = 8. 

        /* caso seja "ambos" mas esteja com o grupo de fornecedor */
        IF  emitente.identific = 3 THEN DO:
            IF  emitente.cod-gr-forn = 0 THEN
                ASSIGN tt-cliente-valid.cod-gr-forn    = 3.

            IF  emitente.tp-desp-padrao = 0 THEN
                ASSIGN tt-cliente-valid.tp-desp-padrao = 8.
        END.

        ASSIGN tt-cliente-valid.cod-emitente = emitente.cod-emitente
               tt-cliente-valid.ind-tipo-movto = 2.

        FIND FIRST int-emitente EXCLUSIVE-LOCK
             WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

         IF NOT AVAIL int-emitente THEN DO:
             CREATE int-emitente.
             ASSIGN int-emitente.cod-emitente = emitente.cod-emitente .
         END.

        FIND FIRST emitente-cex EXCLUSIVE-LOCK
             WHERE emitente-cex.cod-emitente = emitente.cod-emitente NO-ERROR.

        IF NOT AVAIL emitente-cex THEN DO:
             CREATE emitente-cex.
             ASSIGN emitente-cex.cod-emite = emitente.cod-emitente .
        END.

        FIND FIRST int-emitente-cex EXCLUSIVE-LOCK
             WHERE int-emitente-cex.cod-emitente = emitente.cod-emitente NO-ERROR.

        IF NOT AVAIL int-emitente-cex THEN DO:
            CREATE int-emitente-cex.
            ASSIGN int-emitente-cex.cod-emitente = emitente.cod-emitente .                    
        END.

        FIND FIRST int-emitente-canal EXCLUSIVE-LOCK
             WHERE int-emitente-canal.cod-emitente = emitente.cod-emitente NO-ERROR.

         IF NOT AVAIL int-emitente-canal THEN DO:
             CREATE int-emitente-canal.
             ASSIGN int-emitente-canal.cod-emitente = emitente.cod-emitente .
         END.
    END.

    /*BUSCAR A CONTA MATRIZ*/
    FIND FIRST b-int-emit-Matriz-crm NO-LOCK
        WHERE b-int-emit-Matriz-crm.cod-guid = msg0072.ContaPrimaria NO-ERROR.

    IF  AVAIL b-int-emit-Matriz-crm THEN
        FIND FIRST b-emitente NO-LOCK
            WHERE b-emitente.cod-emitente = b-int-emit-Matriz-crm.cod-emitente NO-ERROR.
    
    FIND FIRST gr-cli-class-canal NO-LOCK
         WHERE gr-cli-class-canal.codigo-classificacao = msg0072.Classificacao NO-ERROR.

    /*
    IF (int-emitente.ind-participa-canais <> msg0072.ParticipaProgramaCanais  and
        msg0072.ParticipaProgramaCanais = 993520001) OR
       (int-emitente.guid-class <> msg0072.Classificacao AND
        int-emitente.guid-class = "") THEN DO:
        RUN piEnviaNotasPedidosBarramento.
    END.
    */

    /*Atualizaá∆o da relaá∆o Matriz/filial conforme CRM para efeitos de c†lculo de beneficios*/
    IF AVAIL int-emitente-canal THEN DO:
       IF  AVAIL b-emitente THEN
           ASSIGN int-emitente-canal.cod-emitente-matriz = b-emitente.cod-emitente 
                  int-emitente-canal.guid-filial         = msg0072.CodigoConta          
                  int-emitente-canal.guid-matriz         = b-int-emit-Matriz-crm.cod-guid.  
       ELSE 
           ASSIGN int-emitente-canal.cod-emitente-matriz = tt-cliente-valid.cod-emitente
                  int-emitente-canal.guid-filial         = msg0072.CodigoConta
                  int-emitente-canal.guid-matriz         = msg0072.CodigoConta.
    END.

    IF AVAIL int-emitente-canal THEN DO:
        /*Atualizaá∆o campos do CRM*/
        ASSIGN int-emitente-canal.DescricaoConta                = msg0072.DescricaoConta             
               int-emitente-canal.TipoRelacao                   = msg0072.TipoRelacao                
               int-emitente-canal.SuspensaoCredito              = msg0072.SuspensaoCredito            
               int-emitente-canal.LimiteCredito                 = msg0072.LimiteCredito              
               int-emitente-canal.DataLimiteCredito             = msg0072.DataLimiteCredito          
               int-emitente-canal.SaldoCredito                  = msg0072.SaldoCredito               
               int-emitente-canal.RG                            = msg0072.RG                         
               int-emitente-canal.OrgaoExpeditor                = msg0072.OrgaoExpeditor             
               int-emitente-canal.DescontoAssistenciaTecnica    = msg0072.DescontoAssistenciaTecnica 
               int-emitente-canal.CoberturaGeografica           = msg0072.CoberturaGeografica        
               int-emitente-canal.DataConstituicao              = msg0072.DataConstituicao           
               int-emitente-canal.DistribuicaoUnicaFonteRecei   = msg0072.DistribuicaoUnicaFonteRecei
               int-emitente-canal.DistribuidorPrincipal         = msg0072.DistribuidorPrincipal      
               int-emitente-canal.QualificadoTreinamento        = msg0072.QualificadoTreinamento     
               int-emitente-canal.Historico                     = msg0072.Historico                  
               int-emitente-canal.IntencaoApoio                 = msg0072.IntencaoApoio              
               int-emitente-canal.MetodoComercializacao         = msg0072.MetodoComercializacao      
               int-emitente-canal.ModeloOperacao                = msg0072.ModeloOperacao             
               int-emitente-canal.NumeroFuncionarios            = msg0072.NumeroFuncionarios         
               int-emitente-canal.NumeroColaboradoresAreaTecn   = msg0072.NumeroColaboradoresAreaTecn
               int-emitente-canal.NumeroRevendasAtivas          = msg0072.NumeroRevendasAtivas       
               int-emitente-canal.NumeroRevendasInativas        = msg0072.NumeroRevendasInativas     
               int-emitente-canal.NumeroTecnicosSuporte         = msg0072.NumeroTecnicosSuporte      
               int-emitente-canal.NumeroVendedores              = msg0072.NumeroVendedores           
               int-emitente-canal.OutraFonteReceita             = msg0072.OutraFonteReceita          
               int-emitente-canal.PerfilRevendasDistribuidor    = msg0072.PerfilRevendasDistribuidor 
               int-emitente-canal.PossuiEstruturaCompleta       = msg0072.PossuiEstruturaCompleta    
               int-emitente-canal.PossuiFiliais                 = msg0072.PossuiFiliais              
               int-emitente-canal.QuantidadeFiliais             = msg0072.QuantidadeFiliais          
               int-emitente-canal.PrazoMedioCompra              = msg0072.PrazoMedioCompra           
               int-emitente-canal.PrazoMedioVenda               = msg0072.PrazoMedioVenda            
               int-emitente-canal.Setor                         = msg0072.Setor                      
               int-emitente-canal.RamoAtividadeEconomica        = msg0072.RamoAtividadeEconomica     
               int-emitente-canal.SistemaGestao                 = msg0072.SistemaGestao              
               int-emitente-canal.ValorMedioCompra              = msg0072.ValorMedioCompra           
               int-emitente-canal.ValorMedioVenda               = msg0072.ValorMedioVenda            
               int-emitente-canal.ListaPreco                    = msg0072.ListaPreco                 
               int-emitente-canal.EstruturaPropriedade          = msg0072.EstruturaPropriedade       
               int-emitente-canal.ReceitaAnual                  = msg0072.ReceitaAnual               
               int-emitente-canal.CNAE                          = msg0072.CNAE                       
               int-emitente-canal.NivelPosVenda                 = msg0072.NivelPosVenda              
               int-emitente-canal.TransportadoraRedespacho      = msg0072.TransportadoraRedespacho   
               int-emitente-canal.ContatoPrincipal              = msg0072.ContatoPrincipal           
               int-emitente-canal.transportdora                 = IF  msg0072.Transportadora = ? THEN 0 /*Retira*/ ELSE msg0072.Transportadora
               int-emitente-canal.TipoConstituicao              = msg0072.TipoConstituicao           
               int-emitente-canal.NumeroDiasAtraso              = msg0072.NumeroDiasAtraso           
               int-emitente-canal.ClientePotencialOriginador    = msg0072.ClientePotencialOriginador 
               int-emitente-canal.TipoConta                     = msg0072.TipoConta                  
               int-emitente-canal.OrigemConta                   = msg0072.OrigemConta                
               /*int-emitente-canal.NumeroPassaporte              = msg0072.NumeroPassaporte*/           
               int-emitente-canal.StatusIntegracaoSefaz         = msg0072.StatusIntegracaoSefaz      
               int-emitente-canal.DataHoraIntegracaoSefaz       = IF msg0072.DataHoraIntegracaoSefaz <> ? THEN DATETIME(INT(SUBSTRING(msg0072.DataHoraIntegracaoSefaz,6,2)),int(SUBSTRING(msg0072.DataHoraIntegracaoSefaz,9,2)),int(SUBSTRING(msg0072.DataHoraIntegracaoSefaz,1,4)),int(SUBSTRING(msg0072.DataHoraIntegracaoSefaz,12,2)),int(SUBSTRING(msg0072.DataHoraIntegracaoSefaz,15,2)),int(SUBSTRING(msg0072.DataHoraIntegracaoSefaz,18,2))) ELSE ?
               int-emitente-canal.RegimeApuracao                = msg0072.RegimeApuracao             
               int-emitente-canal.DataBaixaContribuinte         = msg0072.DataBaixaContribuinte
               int-emitente-canal.IntegraTrigger                = NO
               int-emitente-canal.AssistenciaTecnica            = IF msg0072.AssistenciaTecnica = ? THEN NO ELSE msg0072.AssistenciaTecnica
               int-emitente-canal.PerfilAssistenciaTecnica      = msg0072.PerfilAssistenciaTecnica
               int-emitente-canal.TabelaPrecoAssistenciaTecnica = msg0072.TabelaPrecoAssistenciaTecnica
               int-emitente-canal.CodigoRamoAtividadeEconomica  = msg0072.CodigoRamoAtividadeEconomica 
               int-emitente-canal.FiguraNoSite                  = msg0072.FiguraNoSite                 
               int-emitente-canal.ParticipaProgramaCanaisMotivo = msg0072.ParticipaProgramaCanaisMotivo
               int-emitente-canal.AdesaoPciRealizadaPor         = msg0072.AdesaoPciRealizadaPor        
               int-emitente-canal.EscolheuDistrForaSellOut      = msg0072.EscolheuDistrForaSellOut     
               int-emitente-canal.DataUltimoSellOut             = msg0072.DataUltimoSellOut
               int-emitente-canal.Categoria                     = msg0072.Categoria.           
    END.

    IF  l-novo-emitente THEN DO:

        ASSIGN tt-cliente-valid.nome-matriz    = msg0072.NomeAbreviadoMatrizEconomica
               tt-cliente-valid.recebe-inf-sci = YES.

        IF  msg0072.CNPJ <> "" 
        AND msg0072.CNPJ <> ? THEN DO:
            
            log-manager:WRITE-MESSAGE ("1 - CNPJ: " + STRING(msg0072.CNPJ)).

            FIND FIRST b-emitente
                WHERE b-emitente.cgc BEGINS substr(msg0072.CNPJ,1,8) NO-LOCK NO-ERROR.

            IF  AVAIL b-emitente THEN DO:
                log-manager:WRITE-MESSAGE ("2 - CNPJ: " + STRING(msg0072.CNPJ) + " b-emitente.nome-matriz: " + b-emitente.nome-matriz).

                ASSIGN tt-cliente-valid.nome-matriz = b-emitente.nome-matriz.
            END.
            ELSE DO:
                log-manager:WRITE-MESSAGE ("3 - CNPJ: " + STRING(msg0072.CNPJ) + " tt-cliente-valid.nome-abrev: " + tt-cliente-valid.nome-abrev).

                ASSIGN tt-cliente-valid.nome-matriz    = tt-cliente-valid.nome-abrev.
            END.
        END.
    END.
    ELSE
        IF  msg0072.NomeAbreviadoMatrizEconomica <> "" AND msg0072.NomeAbreviadoMatrizEconomica <> ? THEN
            ASSIGN tt-cliente-valid.nome-matriz    = msg0072.NomeAbreviadoMatrizEconomica.

    IF  msg0072.CPF <> ""
    AND msg0072.CPF <> ? 
    AND tt-cliente-valid.nome-matriz = "" THEN
        ASSIGN tt-cliente-valid.nome-matriz = tt-cliente-valid.nome-abrev.

    log-manager:WRITE-MESSAGE ("l-novo-emitente: " + STRING(l-novo-emitente)).
    log-manager:WRITE-MESSAGE ("msg0072.NomeAbreviadoMatrizEconomica: " + STRING(msg0072.NomeAbreviadoMatrizEconomica)).
    log-manager:WRITE-MESSAGE ("tt-cliente-valid.nome-matriz: " + STRING(tt-cliente-valid.nome-matriz)).

    ASSIGN tt-cliente-valid.nome-emit      = msg0072.NomeRazaoSocial
           tt-cliente-valid.nom-fantasia   = msg0072.NomeFantasia
           tt-cliente-valid.telefone[1]    = msg0072.Telefone                      
           tt-cliente-valid.ramal[1]       = IF msg0072.Ramal = ? THEN "0" ELSE msg0072.Ramal                        
           tt-cliente-valid.telefone[2]    = msg0072.TelefoneAlternativo           
           tt-cliente-valid.ramal[2]       = IF msg0072.RamalTelefoneAlternativo = ? THEN "0" ELSE msg0072.RamalTelefoneAlternativo
           tt-cliente-valid.telefax        = IF msg0072.Fax = ? THEN "0" ELSE msg0072.Fax                            
           tt-cliente-valid.ramal-fax      = IF msg0072.RamalFax = ? THEN "0" ELSE msg0072.RamalFax                     
           tt-cliente-valid.e-mail         = msg0072.Email                         
           tt-cliente-valid.home-page      = msg0072.Site        
           tt-cliente-valid.ins-municipal  = msg0072.InscricaoMunicipal
           tt-cliente-valid.modalidade     = IF  NOT l-novo-emitente THEN tt-cliente-valid.modalidade ELSE 6
         /*tt-cliente-valid.emite-bloq     = msg0072.EmiteBloqueto CRM*/
         /*tt-cliente-valid.gera-ad        = msg0072.GeraAvisoCredito CRM*/
         /*tt-cliente-valid.calcula-multa  = msg0072.CalculaMulta CRM*/
         /*tt-cliente-valid.recebe-inf-sci = msg0072.RecebeInformacaoSCI CRM*/

    
           
    /* inicio FISCAL */           
    OVERLAY(tt-cliente-valid.char-1, 21, 1)               = IF msg0072.OptanteSuspensaoIPI THEN "2" ELSE "1" 
    OVERLAY(tt-cliente-valid.char-1, 103, 20)             = msg0072.NumeroPassaporte
            tt-cliente-valid.agente-retencao              = msg0072.AgenteRetencao 
            tt-cliente-valid.contrib-icms                 = msg0072.ContribuinteICMS  
            tt-cliente-valid.log-calcula-pis-cofins-unid  = msg0072.PisCofinsUnidade 
            tt-cliente-valid.log-nf-eletro                = msg0072.RecebeNotaFiscalEletronica 
            tt-cliente-valid.cod-suframa                  = msg0072.CodigoSUFRAMA                  
            tt-cliente-valid.insc-subs-trib               = msg0072.InscricaoSubstituicaoTributaria.

    IF  msg0072.CNPJ <> "" 
    AND msg0072.CNPJ <> ? THEN 
        ASSIGN tt-cliente-valid.cgc = msg0072.CNPJ.
    ELSE IF  msg0072.CPF <> "" 
         AND msg0072.CPF <> ? THEN
        ASSIGN tt-cliente-valid.cgc = msg0072.CPF.
    ELSE 
        ASSIGN tt-cliente-valid.cgc = msg0072.CodigoEstrangeiro.

    ASSIGN i-forma-tributo-antiga = int-emitente.ind-forma-tributo.
    
    IF AVAIL int-emitente THEN DO:
       IF msg0072.FormaTributacao = 993520000 THEN /*Lucro Real*/
           ASSIGN int-emitente.ind-forma-tributo = 1.
       ELSE IF msg0072.FormaTributacao = 993520001 THEN /*Lucro Presumido*/
           ASSIGN int-emitente.ind-forma-tributo = 2.
       ELSE IF msg0072.FormaTributacao = 993520002 THEN /*Simples*/
           ASSIGN int-emitente.ind-forma-tributo = 3.
       ELSE IF msg0072.FormaTributacao = 993520003 THEN /*Nenhum*/
           ASSIGN int-emitente.ind-forma-tributo = 4.
       ELSE IF msg0072.FormaTributacao = 993520004 THEN /*Isento*/
           ASSIGN int-emitente.ind-forma-tributo = 5.   
    END.

    IF AVAILABLE int-emitente AND int-emitente.ind-forma-tributo <> i-forma-tributo-antiga THEN DO:

        FIND FIRST int-emitente-trib NO-LOCK
            WHERE  int-emitente-trib.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.
        IF  AVAIL  int-emitente-trib THEN DO:

            IF int-emitente-trib.ind-declaracao = YES THEN DO:                                                                                                        
                RUN pi-erro (INPUT "Erro: Cliente " + emitente.nome-abrev + " - Declaraªío jˇ entregue. Verificar com o grupo tributario.").
                UNDO blk_principal, LEAVE blk_principal.
            END. /* IF int-emitente-trib.ind-declaracao = YES THEN DO: */

        END. /* IF  AVAIL  int-emitente-trib THEN DO: */

   END. /* IF AVAILABLE int-emitente AND int-emitente.ind-forma-tributo <> tt-cliente.ind-forma-tributo THEN DO: */

   IF AVAIL int-emitente THEN DO:
       ASSIGN int-emitente.ind-vendas-alc    = IF Msg0072.VendeAtacadista = YES THEN 1 ELSE 0.
       ASSIGN int-emitente.dt-vcto-concessao = msg0072.DataVencimentoConcessao.
   END.
   /* fim FISCAL */
   
   ASSIGN int-emitente.observacao-ped          = msg0072.ObservacaoPedido               
          int-emitente.tipo-embalagem          = msg0072.TipoEmbalagem                  
          emitente-cex.cod-incoterm-exp        = msg0072.CodigoIncoterm                 
          int-emitente-cex.local-embarque      = msg0072.LocalEmbarque                  
          int-emitente-cex.embarque-via        = msg0072.ViaEmbarque                    
          int-emitente.exclusividade           = msg0072.Exclusividade
          int-emitente.ind-participa-canais    = msg0072.ParticipaProgramaCanais /*993520000: N∆o 993520001: Sim 993520002: Descredenciado */
          int-emitente.dispositivo-legal       = msg0072.ObservacaoNotaFiscal
          int-emitente.id-ativo                = IF msg0072.Situacao = 1 THEN NO ELSE YES
          int-emitente.guid-class              = msg0072.Classificacao
          int-emitente.guid-subclass           = msg0072.Subclassificacao
          int-emitente.guid-class              = msg0072.Classificacao
          tt-cliente-valid.portador            = IF NOT l-novo-emitente THEN tt-cliente-valid.portador ELSE 999
          int-emitente.guid-regiao             = msg0072.Regiao
          int-emitente.ind-apuracao-beneficio  = msg0072.ApuracaoBeneficio
          int-emitente.proprietario            = msg0072.Proprietario
          int-emitente.tipo-proprietario       = msg0072.TipoProprietario
          int-emitente.dt-adesao-canais        = msg0072.DataAdesao
          int-emitente.cod-guid                = msg0072.CodigoConta
          tt-cliente-valid.cod-entrega         = "Padr∆o":U
          tt-cliente-valid.cgc-cob             = tt-cliente-valid.cgc
          tt-cliente-valid.end-cobranca        = tt-cliente-valid.cod-emitente
          tt-cliente-valid.idi-tributac-pis    = IF tt-cliente-valid.contrib-icms = YES THEN 1 ELSE 2
          tt-cliente-valid.idi-tributac-cofins = IF tt-cliente-valid.contrib-icms = YES THEN 1 ELSE 2.

    IF msg0072.DataImplantacao <> ? THEN
        ASSIGN tt-cliente-valid.data-implant = msg0072.DataImplantacao.

    /*Esses campos devem ser atualizados somente pelo totvs*/
/*     IF  msg0072.NumeroBanco <> ?                                            */
/*     AND msg0072.NumeroBanco <> 0 THEN                                       */
/*         ASSIGN tt-cliente-valid.cod-banco = msg0072.NumeroBanco.            */
/*                                                                             */
/*     IF  msg0072.NumeroAgencia <> ?                                          */
/*     AND msg0072.NumeroAgencia <> "" THEN                                    */
/*         ASSIGN tt-cliente-valid.agencia   = msg0072.NumeroAgencia.          */
/*                                                                             */
/*     IF  msg0072.NumeroContaCorrente <> ?                                    */
/*     AND msg0072.NumeroContaCorrente <> "" THEN                              */
/*         ASSIGN tt-cliente-valid.conta-corren = msg0072.NumeroContaCorrente. */

    IF  msg0072.ReceitaPadrao <> ? 
    AND msg0072.ReceitaPadrao <> 0 THEN 
        ASSIGN tt-cliente-valid.tp-rec-padrao  = msg0072.ReceitaPadrao.

    IF  msg0072.CondicaoPagamento <> ? 
    AND msg0072.CondicaoPagamento <> 0 THEN 
        ASSIGN tt-cliente-valid.cod-cond-pag = msg0072.CondicaoPagamento.

    IF  msg0072.InscricaoEstadual <> ? 
    AND msg0072.InscricaoEstadual <> "" THEN 
        ASSIGN tt-cliente-valid.ins-estadual = msg0072.InscricaoEstadual. 

    IF  msg0072.InscricaoMunicipal <> ? 
    AND msg0072.InscricaoMunicipal <> "" THEN 
        ASSIGN tt-cliente-valid.ins-municipal = msg0072.InscricaoMunicipal.

    IF AVAIL EnderecoPrincipal THEN DO:        

        ASSIGN tt-cliente-valid.cep          = EnderecoPrincipal.CEP
               tt-cliente-valid.endereco     = trim(EnderecoPrincipal.Logradouro) + ", " + trim(string(EnderecoPrincipal.Numero)) + " - " + trim(EnderecoPrincipal.Complemento)
               tt-cliente-valid.bairro       = EnderecoPrincipal.Bairro
               tt-cliente-valid.cidade       = EnderecoPrincipal.NomeCidade 
               tt-cliente-valid.estado       = EnderecoPrincipal.UF 
               tt-cliente-valid.pais         = EnderecoPrincipal.NomePais
               tt-cliente-valid.caixa-postal = EnderecoPrincipal.CaixaPostal.

        FIND FIRST loc-entr EXCLUSIVE-LOCK
             WHERE loc-entr.nome-abrev  = tt-cliente-valid.nome-abrev
               AND loc-entr.cod-entrega = "Padr∆o":U NO-ERROR.
         
        IF NOT AVAILABLE loc-entr THEN DO:
            CREATE loc-entr.
            ASSIGN loc-entr.nome-abrev   = tt-cliente-valid.nome-abrev
                   loc-entr.cod-entrega  = "Padr∆o":U.
        END.

        ASSIGN loc-entr.endereco = "":U.
        IF tt-cliente-valid.endereco <> "":U THEN DO:
            ASSIGN loc-entr.endereco = tt-cliente-valid.endereco.
        END.
        
        ASSIGN loc-entr.bairro         = tt-cliente-valid.bairro
               loc-entr.cidade         = tt-cliente-valid.cidade
               loc-entr.estado         = tt-cliente-valid.estado
               loc-entr.cep            = REPLACE(tt-cliente-valid.cep, "-":U, "":U)
               loc-entr.pais           = tt-cliente-valid.pais
               loc-entr.cgc            = tt-cliente-valid.cgc
               loc-entr.ins-estadual   = tt-cliente-valid.ins-estadual
               loc-entr.nom-cidad-cif  = tt-cliente-valid.cidade
               loc-entr.nome-transp    = "RETIRA". 

        IF  NOT msg0072.Transportadora = ? THEN DO:
            find first transporte no-lock
                where transporte.cod-transp =  msg0072.Transportadora no-error.
            IF  AVAIL transporte THEN
                ASSIGN loc-entr.nome-transp = transporte.nome-abrev.
        END.
               
        FIND FIRST int-loc-entr EXCLUSIVE-LOCK 
             WHERE int-loc-entr.nome-abrev  = loc-entr.nome-abrev
               AND int-loc-entr.cod-entrega = loc-entr.cod-entrega NO-ERROR.

        IF NOT AVAILABLE int-loc-entr THEN DO:
            CREATE int-loc-entr.
            ASSIGN int-loc-entr.nome-abrev  = loc-entr.nome-abrev
                   int-loc-entr.cod-entrega = loc-entr.cod-entrega.
        END.

        ASSIGN int-loc-entr.endereco-completo = loc-entr.endereco
               int-loc-entr.logradouro  = trim(EnderecoPrincipal.Logradouro) 
               int-loc-entr.numero      = trim(string(EnderecoPrincipal.Numero))
               int-loc-entr.complemento = trim(EnderecoPrincipal.Complemento).

        FIND CURRENT loc-entr NO-LOCK NO-ERROR.

        IF AVAIL int-emitente-canal THEN DO:
            ASSIGN int-emitente-canal.NomeEndereco = EnderecoPrincipal.NomeEndereco
                   int-emitente-canal.TipoEndereco = EnderecoPrincipal.TipoEndereco
                   /*int-emitente-canal.CaixaPostal  = EnderecoPrincipal.CaixaPostal */
                   int-emitente-canal.Estado       = EnderecoPrincipal.Estado      
                   int-emitente-canal.Pais         = EnderecoPrincipal.Pais        
                   int-emitente-canal.NomeContato  = EnderecoPrincipal.NomeContato 
                   int-emitente-canal.Telefone     = EnderecoPrincipal.Telefone    
                   int-emitente-canal.Fax          = EnderecoPrincipal.Fax.                                              
        END.

        IF AVAIL int-emitente THEN DO:
            ASSIGN int-emitente.logradouro  = trim(EnderecoPrincipal.Logradouro)      
                   int-emitente.numero      = trim(string(EnderecoPrincipal.Numero))  
                   int-emitente.complemento = trim(EnderecoPrincipal.Complemento).    
        END.
    END. 

    IF AVAIL EnderecoCobranca THEN DO:  
        ASSIGN tt-cliente-valid.endereco-cob = trim(EnderecoCobranca.Logradouro) + ", " + trim(string(EnderecoCobranca.Numero)) + " - " + trim(string(EnderecoCobranca.Complemento))
               tt-cliente-valid.bairro-cob   = EnderecoCobranca.Bairro
               tt-cliente-valid.cidade-cob   = EnderecoCobranca.NomeCidade
               tt-cliente-valid.estado-cob   = EnderecoCobranca.UF
               tt-cliente-valid.pais-cob     = EnderecoCobranca.NomePais
               tt-cliente-valid.cep-cob      = EnderecoCobranca.cep
               tt-cliente-valid.cx-post-cob  = EnderecoCobranca.CaixaPostal.
     
        IF AVAIL int-emitente-canal THEN DO:
         ASSIGN int-emitente-canal.NomeEnderecoCob = EnderecoCobranca.NomeEndereco
                int-emitente-canal.TipoEnderecoCob = EnderecoCobranca.TipoEndereco
                /*int-emitente-canal.CaixaPostalCob  = EnderecoCobranca.CaixaPostal */
                int-emitente-canal.EstadoCob       = EnderecoCobranca.Estado      
                int-emitente-canal.PaisCob         = EnderecoCobranca.Pais        
                int-emitente-canal.NomeContatoCob  = EnderecoCobranca.NomeContato 
                int-emitente-canal.TelefoneCob     = EnderecoCobranca.Telefone    
                int-emitente-canal.FaxCob          = EnderecoCobranca.Fax.                                            
        END.
        IF AVAIL int-emitente THEN DO:
            ASSIGN int-emitente.logradouro-cob  = trim(EnderecoCobranca.Logradouro)      
                   int-emitente.numero-cob      = trim(string(EnderecoCobranca.Numero))  
                   int-emitente.complemento-cob = trim(EnderecoCobranca.Complemento).    
        END.
    END.
    ELSE DO:
        ASSIGN tt-cliente-valid.endereco-cob = trim(EnderecoPrincipal.Logradouro) + ", " + trim(string(EnderecoPrincipal.Numero)) + " - " + trim(EnderecoPrincipal.Complemento)
               tt-cliente-valid.bairro-cob   = EnderecoPrincipal.Bairro                                                                                                       
               tt-cliente-valid.cidade-cob   = EnderecoPrincipal.NomeCidade                                                                                                   
               tt-cliente-valid.estado-cob   = EnderecoPrincipal.UF                                                                                                           
               tt-cliente-valid.pais-cob     = EnderecoPrincipal.NomePais                                                                                                   
               tt-cliente-valid.cep-cob      = EnderecoPrincipal.CEP
               tt-cliente-valid.cx-post-cob  = EnderecoPrincipal.CaixaPostal.

        IF AVAIL int-emitente-canal THEN DO:
            ASSIGN int-emitente-canal.NomeEnderecoCob = EnderecoPrincipal.NomeEndereco
                   int-emitente-canal.TipoEnderecoCob = EnderecoPrincipal.TipoEndereco
                   /*int-emitente-canal.CaixaPostalCob  = EnderecoPrincipal.CaixaPostal*/ 
                   int-emitente-canal.EstadoCob       = EnderecoPrincipal.Estado      
                   int-emitente-canal.PaisCob         = EnderecoPrincipal.Pais        
                   int-emitente-canal.NomeContatoCob  = EnderecoPrincipal.NomeContato 
                   int-emitente-canal.TelefoneCob     = EnderecoPrincipal.Telefone    
                   int-emitente-canal.FaxCob          = EnderecoPrincipal.Fax.                                             
        END.
        IF AVAIL int-emitente THEN DO:
            ASSIGN int-emitente.logradouro-cob  = trim(EnderecoPrincipal.Logradouro)      
                   int-emitente.numero-cob      = trim(string(EnderecoPrincipal.Numero))  
                   int-emitente.complemento-cob = trim(EnderecoPrincipal.Complemento).    
        END.
    END.

    ASSIGN tt-cliente-valid.cod-rep = IF msg0072.CodigoRepresentante = ? THEN 4000 ELSE msg0072.CodigoRepresentante.
           tt-cliente-valid.cod-gr-cli       = IF AVAIL gr-cli-class-canal THEN gr-cli-class-canal.cod-gr-cli ELSE 0.

    ASSIGN tt-cliente-valid.modalidade-ap    = IF NOT l-novo-emitente THEN tt-cliente-valid.modalidade-ap ELSE 6
           tt-cliente-valid.portador-ap      = IF NOT l-novo-emitente THEN tt-cliente-valid.portador-ap   ELSE 999
           tt-cliente-valid.ind-abrange-aval = 2
           tt-cliente-valid.tip-cob-desp     = 2
           tt-cliente-valid.ind-aval         = 3
           tt-cliente-valid.cod-transp       = IF  msg0072.Transportadora = ? THEN 0 /*Retira*/ ELSE msg0072.Transportadora.
           


    /*Tarefa 2171: grupo 26 - BNDES seja parametrizado para n∆o enviar a cart¢rio.*/
    IF tt-cliente-valid.cod-gr-cli = 26 THEN
        ASSIGN tt-cliente-valid.ins-banc = 7.

    /*IF msg0072.SuspensaoCredito THEN
        ASSIGN tt-cliente-valid.ind-cre-cli = 4. /*????*/ comentado por solicitaá∆o do Cenci*/

    IF l-novo-emitente THEN DO:

        IF tt-cliente-valid.cod-gr-cli = 30 /*pos vendas*/ THEN DO:
            ASSIGN tt-cliente-valid.ind-cre-cli = 1
                   tt-cliente-valid.observacoes = "Liberado sem avaliaá∆o de crÇdito para p¢s venda":U
                   tt-cliente-valid.lim-credito = 0 
                   tt-cliente-valid.dt-lim-cred = DATE(01, 01, 1990).
        END.
        ELSE IF tt-cliente-valid.cod-gr-cli = 95 THEN DO:
             ASSIGN tt-cliente-valid.ind-cre-cli = 1
                    tt-cliente-valid.observacoes = "Cliente faz parte do programa fidelidade e n∆o possui documentaá∆o para fins de crÇdito"
                    tt-cliente-valid.lim-credito = 0    
                    tt-cliente-valid.dt-lim-cred = DATE(01, 01, 1990).
        END.
        ELSE DO:
            FIND FIRST ponto-programa
                WHERE ponto-programa.nome-programa = "escrm004":U
                  AND ponto-programa.ponto         = 2 NO-LOCK NO-ERROR.
        
            IF AVAILABLE ponto-programa THEN DO:            /* conforme chamado 59312 */
                IF CAN-FIND(FIRST conteudo-programa NO-LOCK
                            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                              AND tt-cliente-valid.cgc BEGINS ENTRY(1,conteudo-programa.conteudo,",")) THEN DO:

                    ASSIGN tt-cliente-valid.ind-cre-cli = 1
                           tt-cliente-valid.observacoes = "Cliente Banco - parametrizado para entrar com parametro de credito NORMAL"
                           tt-cliente-valid.lim-credito = 0    /* novos clientes Embratel entra com Automatico */
                           tt-cliente-valid.dt-lim-cred = DATE(01, 01, 1990).

                    IF AVAIL int-emitente THEN
                       ASSIGN int-emitente.cod-gr-cob = 6.
                END.
                ELSE
                    ASSIGN tt-cliente-valid.ind-cre-cli = 4. /* conforme chamado 59312 */
            END.
            ELSE
                ASSIGN tt-cliente-valid.ind-cre-cli = 4. /* conforme chamado 59312 */
        END.
    END.

   // ASSIGN int-emitente.cod-gr-cob = msg0072.CodigoGrupoCobranca.

    log-manager:WRITE-MESSAGE ("1 - credito - msg0072.OrigemConta " + string(msg0072.OrigemConta)).

    ASSIGN v_log_grupo_cob = NO.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "dps-canal-vd", /* grupos tratados para pedidos */
                       INPUT 1,              /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    IF  CAN-FIND (FIRST tt-prog-ponto
                    WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN
        ASSIGN v_log_grupo_cob = YES.


    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "dp3-canal-vd", /* Nome do programa */
                       INPUT 1,         /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    IF  CAN-FIND (FIRST tt-prog-ponto
                     WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:

        log-manager:WRITE-MESSAGE ("2 b - andrey").

        IF  v_log_grupo_cob = YES THEN DO:
            ASSIGN tt-cliente-valid.ind-lib-estoque   = YES
                   tt-cliente-valid.user-libcre       = "DEPS"
                   tt-cliente-valid.ind-aval          = 1
                   tt-cliente-valid.ind-aval-embarque = 2.
            
            IF  l-novo-emitente THEN DO:
                IF  msg0072.LimiteCredito > 0 THEN DO:
                    log-manager:WRITE-MESSAGE ("3.1 - grava limite e status de credito normal").
        
                    ASSIGN tt-cliente-valid.ind-cre-cli = 1
                           tt-cliente-valid.lim-credito = msg0072.LimiteCredito              
                           tt-cliente-valid.dt-lim-cred = msg0072.DataLimiteCredito.
                END.
                ELSE DO:
                    log-manager:WRITE-MESSAGE ("4.1 - ttt status de credito suspenso").
        
                    ASSIGN tt-cliente-valid.ind-cre-cli = 5
                           tt-cliente-valid.lim-credito = msg0072.LimiteCredito.
                           tt-cliente-valid.dt-lim-cred = ?.
                END.
            END.
        END.
        ELSE DO:
            IF  l-novo-emitente THEN DO:
                IF  msg0072.LimiteCredito > 0 THEN DO:
                    log-manager:WRITE-MESSAGE ("3.2 - grava limite e status de credito normal").
        
                    ASSIGN tt-cliente-valid.lim-credito = msg0072.LimiteCredito              
                           tt-cliente-valid.dt-lim-cred = msg0072.DataLimiteCredito.
                END.
                ELSE DO:
                    log-manager:WRITE-MESSAGE ("4.2 - ttt status de credito suspenso").
        
                    ASSIGN tt-cliente-valid.lim-credito = msg0072.LimiteCredito.
                           tt-cliente-valid.dt-lim-cred = ?.
                END.
            END.
        END.

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "n-envia-bco", /* portadores de carteira sem envio ao banco - chamado: 147545 */
                           INPUT 1,              /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        IF  tt-cliente-valid.cod-gr-cli = 25 
        OR (CAN-FIND (FIRST tt-prog-ponto
                        WHERE tt-prog-ponto.conteudo = tt-cliente-valid.nome-matriz)) THEN DO:

            ASSIGN tt-cliente-valid.portador   = 999
                   tt-cliente-valid.modalidade = 1.
        END.
    END.
    ELSE DO:
        IF  msg0072.OrigemConta = 993520007 THEN DO: /* Plataforma Solar - chamado 127506 */
            log-manager:WRITE-MESSAGE ("5 - Plataforma Solar").

            ASSIGN tt-cliente-valid.ind-cre-cli     = 2 /* automatico */
                   int-emitente.cod-gr-cob          = 80
                   tt-cliente-valid.lim-credito     = 1
                   tt-cliente-valid.dt-lim-cred     = 01/01/2990
                   tt-cliente-valid.user-libcre     = "PltSolar"
                   tt-cliente-valid.ind-lib-estoque = YES.
        END.
        ELSE DO:

            IF  msg0072.OrigemConta     = 993520002 /* Itec / konviva */
            OR  int-emitente.cod-gr-cob = 98 THEN DO:
                log-manager:WRITE-MESSAGE ("5.1 - Konviva").

                ASSIGN tt-cliente-valid.ind-cre-cli     = 2 /* automatico */
                       int-emitente.cod-gr-cob          = 98
                       tt-cliente-valid.lim-credito     = 1
                       tt-cliente-valid.dt-lim-cred     = 01/01/2990
                       tt-cliente-valid.user-libcre     = "Especial"
                       tt-cliente-valid.ind-lib-estoque = YES.
            END.
            ELSE DO:
                EMPTY TEMP-TABLE tt-prog-ponto.
                RUN esp/es0018p.p (INPUT "MSG0072":U,
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "":U,
                                   OUTPUT TABLE tt-prog-ponto).
    
                FOR EACH tt-prog-ponto:
    
                    DO  i-ind = 1 TO NUM-ENTRIES(tt-prog-ponto.conteudo,";"):
    
                        IF string(tt-cliente-valid.cod-gr-cli) = ENTRY(i-ind, tt-prog-ponto.conteudo, ";") THEN DO:
                            LOG-MANAGER:WRITE-MESSAGE("6 - P¢s venda e E-Commerce").
    
                            ASSIGN tt-cliente-valid.ind-cre-cli = 5 /* Ö vista */
                                   tt-cliente-valid.observacoes = "Liberado sem avaliaá∆o de crÇdito para pagamento Ö vista":U
                                   tt-cliente-valid.lim-credito = 1
                                   tt-cliente-valid.dt-lim-cred = DATE(01, 01, 2990).
    
                            IF AVAIL int-emitente THEN
                               ASSIGN int-emitente.cod-gr-cob = tt-prog-ponto.sequencia.
    
                            IF  int-emitente.cod-gr-cob = 17 THEN
                                ASSIGN tt-cliente-valid.user-libcre = "Posvenda".
    
                            IF  int-emitente.cod-gr-cob = 9 THEN
                                ASSIGN tt-cliente-valid.user-libcre = "E-commerce".
    
                            ASSIGN tt-cliente-valid.ind-lib-estoque = YES.
                        END.
                    END.
                END.
            END.
        END.
    END.

    /* andrey 2 */

    FIND FIRST grupo-canais-clientes
        WHERE grupo-canais-clientes.cod-gr-cli = tt-cliente-valid.cod-gr-cli NO-LOCK NO-ERROR.

    IF NOT AVAIL grupo-canais-clientes THEN DO:
        RUN pi-erro (INPUT "Grupo de Cliente " + string(tt-cliente-valid.cod-gr-cli) + " n∆o vinculado a grupo de canais.").
    END.
    ELSE DO:
        ASSIGN tt-cliente-valid.cod-entrega    = "Padr∆o":U
               tt-cliente-valid.cod-cond-pag   = msg0072.CondicaoPagamento
               tt-cliente-valid.cod-suframa    = msg0072.CodigoSUFRAMA                  
               tt-cliente-valid.insc-subs-trib = msg0072.InscricaoSubstituicaoTributaria.
    END.

    EMPTY TEMP-TABLE tt-versao-integr.
    CREATE tt-versao-integr.
    ASSIGN tt-versao-integr.cod-versao-integracao = 001.

    /***************************/
    EMPTY TEMP-TABLE tt-dist-emit-valid.

    FIND FIRST dist-emitente NO-LOCK
         WHERE dist-emitente.cod-emitente = tt-cliente-valid.cod-emitente NO-ERROR.
    
    IF NOT AVAIL dist-emitente THEN DO:
    
        CREATE tt-dist-emit-valid.
        ASSIGN tt-dist-emit-valid.ind-tipo-movto              = 1 /*Criaá∆o*/
               tt-dist-emit-valid.cod-emitente                = tt-cliente-valid.cod-emitente
               tt-dist-emit-valid.ind-atua-bonif-canc-saldo   = 1 /* nao cancela */
               tt-dist-emit-valid.log-libera-venda-sem-bonif  = yes
               tt-dist-emit-valid.ind-tp-frete                = 1 /*cif */
               tt-dist-emit-valid.idi-sit-fornec              = 1
               tt-dist-emit-valid.log-consid-ap-lim-cr        = no
               tt-dist-emit-valid.idi-confir-programac-entreg = 1 
               tt-dist-emit-valid.idi-agrup-item              = 1
               tt-dist-emit-valid.idi-niv-aces                = 1.
        
        /* Verifica de o Modulo de descontos e Bonificacoes foi implantado no sistema*/
        FIND FIRST param-global NO-LOCK NO-ERROR.
        IF param-global.modulo-09 = YES THEN DO: /*modulo BN implantado*/     
        
           FIND FIRST para-ped NO-LOCK NO-ERROR.
        
           FIND FIRST param-bonif NO-LOCK 
                WHERE param-bonif.cod-estabel = para-ped.estab-padrao NO-ERROR.
        
           IF AVAIL param-bonif THEN
        
              ASSIGN tt-dist-emit-valid.ind-geracao-ped-bonif = param-bonif.ind-geracao-ped-bonif
                     tt-dist-emit-valid.log-bonif-junto-venda = param-bonif.log-bonif-junto-venda.                
        
        END.
    END.
    /***************************/

    LOG-MANAGER:WRITE-MESSAGE("antes cdapi329").

    RUN cdp/cdapi329.p (INPUT  TABLE tt-versao-integr,
                        OUTPUT TABLE tt-erros-geral,
                        INPUT  TABLE tt-cliente-valid,
                        INPUT  TABLE tt-loc-entr-valid,
                        INPUT  TABLE tt-dist-emit-valid).

    LOG-MANAGER:WRITE-MESSAGE("0 - tt-cliente-valid.cod-emitente: " + STRING(tt-cliente-valid.cod-emitente)).
    LOG-MANAGER:WRITE-MESSAGE("0 - tt-cliente-valid.ind-tipo-movto: " + STRING(tt-cliente-valid.ind-tipo-movto)).

    FIND FIRST emitente EXCLUSIVE-LOCK
         WHERE emitente.cod-emitente = tt-cliente-valid.cod-emitente NO-ERROR.

    IF  AVAIL tt-cliente-valid 
    AND AVAIL emitente THEN DO:
        LOG-MANAGER:WRITE-MESSAGE("msg0072 - atualiza emitente - credito apos cdapi329").

        ASSIGN emitente.ind-cre-cli     = tt-cliente-valid.ind-cre-cli
               emitente.observacoes     = tt-cliente-valid.observacoes
               emitente.lim-credito     = tt-cliente-valid.lim-credito
               emitente.dt-lim-cred     = tt-cliente-valid.dt-lim-cred
               emitente.user-libcre     = tt-cliente-valid.user-libcre
               emitente.ind-lib-estoque = tt-cliente-valid.ind-lib-estoque.

        ASSIGN emitente.cod-suframa     = tt-cliente-valid.cod-suframa   
               emitente.insc-subs-trib  = tt-cliente-valid.insc-subs-trib.
    END.


    LOG-MANAGER:WRITE-MESSAGE("0.1 - avail emitente: " + STRING(AVAIL emitente)).
    LOG-MANAGER:WRITE-MESSAGE("0.2 - locked emitente: " + STRING(LOCKED emitente)).

    /* andrey 1 */
    IF AVAIL emitente THEN DO:
        /*
        LOG-MANAGER:WRITE-MESSAGE("1 - emitente.nome-matriz: "         + STRING(emitente.nome-matriz)).
        LOG-MANAGER:WRITE-MESSAGE("2 - tt-cliente-valid.nome-matriz: " + STRING(tt-cliente-valid.nome-matriz)).
        IF  emitente.nome-matriz <>  tt-cliente-valid.nome-matriz THEN
            ASSIGN emitente.nome-matriz = tt-cliente-valid.nome-matriz.
        */


        LOG-MANAGER:WRITE-MESSAGE("7 - emitente.nome-matriz: " + STRING(emitente.nome-matriz)).

    END.
    ELSE DO:
        RUN pi-erro (INPUT "N∆o foi poss°vel criar o emitente, erro inesperado.").
    END.

    FOR EACH tt-erros-geral
        WHERE tt-erros-geral.cod-erro <> 18655:

        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cgc = emitente.cgc NO-ERROR.
        IF AVAIL estabelec AND tt-erros-geral.cod-erro = 973 THEN NEXT.

        RUN pi-erro (INPUT tt-erros-geral.des-erro).
    END.

    IF CAN-FIND (FIRST tt-erro) THEN DO:
        UNDO blk_principal, LEAVE blk_principal.
    END.
    ELSE DO:
        IF ERROR-STATUS:ERROR THEN DO:
            DEFINE VARIABLE i AS INTEGER     NO-UNDO.
            DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
                IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE(STRING(ERROR-STATUS:GET-MESSAGE(i))).
            END.
            UNDO blk_principal, LEAVE blk_principal.
        END.
    END.


    /* ALTERAÄ«O MATRIZ ECON‚MICA */

    DEF VAR c-matriz-crm AS CHAR FORMAT "x(12)" NO-UNDO.
    IF  emitente.nome-matriz <> tt-cliente-valid.nome-matriz THEN DO:
        LOG-MANAGER:WRITE-MESSAGE("4 - tt-cliente-valid.nome-matriz: "         + STRING(tt-cliente-valid.nome-matriz)).
        ASSIGN c-matriz-crm = tt-cliente-valid.nome-matriz.
        FIND FIRST emitente EXCLUSIVE-LOCK
             WHERE emitente.cod-emitente = tt-cliente-valid.cod-emitente NO-ERROR.
        IF  AVAIL emitente THEN DO:
    
            EMPTY TEMP-TABLE tt-versao-integr.
            EMPTY TEMP-TABLE tt-erros-geral.   
            EMPTY TEMP-TABLE tt-cliente-valid. 
            EMPTY TEMP-TABLE tt-loc-entr-valid.
            EMPTY TEMP-TABLE tt-dist-emit-valid.
    
            CREATE tt-cliente-valid.
            BUFFER-COPY emitente TO tt-cliente-valid.
            ASSIGN emitente.nome-matriz            = c-matriz-crm
                   tt-cliente-valid.nome-matriz    = c-matriz-crm
                   tt-cliente-valid.ind-tipo-movto = 2.
            EMPTY TEMP-TABLE tt-versao-integr.
            CREATE tt-versao-integr.
            ASSIGN tt-versao-integr.cod-versao-integracao = 001.
    
            LOG-MANAGER:WRITE-MESSAGE("5 - emitente.nome-matriz: "         + STRING(emitente.nome-matriz)).

            RUN cdp/cdapi329.p (INPUT  TABLE tt-versao-integr,
                                OUTPUT TABLE tt-erros-geral,
                                INPUT  TABLE tt-cliente-valid,
                                INPUT  TABLE tt-loc-entr-valid,
                                INPUT  TABLE tt-dist-emit-valid).
            FOR EACH tt-erros-geral
                WHERE tt-erros-geral.cod-erro <> 18655:

                RUN pi-erro (INPUT tt-erros-geral.des-erro).
            END.
        
            IF CAN-FIND (FIRST tt-erro) THEN DO:
                UNDO blk_principal, LEAVE blk_principal.
            END.
            ELSE DO:
                IF ERROR-STATUS:ERROR THEN DO:
                    DEFINE VARIABLE j AS INTEGER     NO-UNDO.
                    DO j = 1 TO ERROR-STATUS:NUM-MESSAGES:
                        IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE(STRING(ERROR-STATUS:GET-MESSAGE(j))).
                    END.
                    UNDO blk_principal, LEAVE blk_principal.
                END.
            END.
        END.
    END.

    LOG-MANAGER:WRITE-MESSAGE("6 - avail emitente: "  + string(AVAIL emitente)).
    IF AVAIL emitente THEN DO: 

        FIND FIRST wm-cliente NO-LOCK
             WHERE wm-cliente.cod-cliente = emitente.cod-emitente
               AND wm-cliente.nome-abrev  = emitente.nome-abrev NO-ERROR.
        IF NOT AVAIL wm-cliente THEN DO:
            EMPTY TEMP-TABLE RowErrors.
            IF NOT VALID-HANDLE(h-prx073) THEN
               RUN wmp/wmprx073.p PERSISTENT SET h-prx073.
           
            /*cria a tabela wm-cliente*/
            RUN replicaCliente IN h-prx073(INPUT emitente.cod-emitente,
                                           INPUT emitente.nome-abre,
                                           OUTPUT TABLE RowErrors).
           
            IF CAN-FIND (FIRST RowErrors) THEN DO:
               FOR EACH RowErrors:
                   RUN pi-erro (INPUT RowErrors.ErrorDescription).
               END.
               RUN destroy IN h-prx073.
               UNDO blk_principal, LEAVE blk_principal.
            END.
            RUN destroy IN h-prx073.
        END.
    END. 


END. /*blk_principal*/

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0072r.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.
ASSIGN cabecalhor.CodigoMensagem    = 'MSG0072R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

IF CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso        = NO
           resultado.CodigoErro     = 17006
           resultado.Mensagem       = ""
           msg0072r.CodigoCliente   = ? 
           msg0072r.Proprietario    = ?
           msg0072r.TipoProprietari = ?
           msg0072r.CodigoConta     = ?.

    FOR EACH tt-erro:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + ";" .
    END.
END.
ELSE 
    ASSIGN msg0072r.CodigoCliente                 = tt-cliente-valid.cod-emitente
           msg0072r.Proprietario                  = int-emitente.proprietario
           msg0072r.TipoProprietari               = int-emitente.tipo-proprietario
           msg0072r.CodigoConta                   = msg0072.CodigoConta
           msg0072r.NomeAbreviado                 = tt-cliente-valid.nome-abrev
           msg0072r.NomeAbreviadoMatrizEconomica  = tt-cliente-valid.nome-matriz.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

ASSIGN int-emitente-canal.IntegraTrigger = YES. /*Marca para enviar viar trigger*/

RETURN.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

PROCEDURE piEnviaNotasPedidosBarramento:
    
    CREATE tt-param.
    ASSIGN tt-param.usuario      = c-seg-usuario
           tt-param.destino      = 2
           tt-param.data-exec    = today
           tt-param.hora-exec    = time
           tt-param.ind-execucao = 2
           tt-param.cod-emitente = emitente.cod-emitente.
    ASSIGN c-programa-mg97 = "esesb011rp"
           c-versao-mg97   = "1.00.00.000".
    
    /*Alterado 14/02/2005 - tech1007 - Alterado o teste para verificar se a opá∆o de RTF est† selecionada*/
    ASSIGN tt-param.arquivo = "esesb011".

    RAW-TRANSFER tt-param TO raw-param.

    FOR EACH tt-raw-digita:
        DELETE tt-raw-digita.
    END.

    FOR EACH tt-digita:
        CREATE tt-raw-digita.
        RAW-TRANSFER tt-digita TO tt-raw-digita.raw-digita.
    END.  

    ASSIGN p_cod_prog_dtsul_w  = "esesb011rp"           
           p_cod_prog_dtsul_rp = "esp/esb/esesb011rp.p"
           p_cod_release       = '2.00.00.000'                    
           p_cdn_estil_dwb     = 97                   
           p_arquivo           = "esesb011rp.tmp" 
           p_destino           = 2                    
           p_raw_param         = raw-param.  

    CREATE tt_param_segur.
    ASSIGN tt_param_segur.tta_num_vers_integr_api      = 3
           tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
           tt_param_segur.tta_cod_empres_usuar         = STRING(i-ep-codigo-usuario)
           tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
           tt_param_segur.tta_cod_idiom_usuar          = "POR":U
           tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
           tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
           tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
           tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.

    CREATE tt_ped_exec.
    ASSIGN tt_ped_exec.tta_num_seq                = 1
           tt_ped_exec.tta_cod_usuario            = v_cod_usuar_corren
           tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w 
           tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp
           tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release      
           tt_ped_exec.tta_dat_exec_ped_exec      = TODAY
           tt_ped_exec.tta_hra_exec_ped_exec      = REPLACE(STRING(TIME,"HH:MM:SS"), ":", "")
           tt_ped_exec.tta_cod_servid_exec        = "rpw3"
           tt_ped_exec.tta_cdn_estil_dwb          = 97.

    CREATE tt_ped_exec_param.
    ASSIGN tt_ped_exec_param.tta_num_seq         = 1
           tt_ped_exec_param.tta_cod_dwb_file    = "esp/esesb011rp.p"
           tt_ped_exec_param.tta_cod_dwb_output  = 'Arquivo'
           tt_ped_exec_param.tta_nom_dwb_printer = p_arquivo.

    RAW-TRANSFER tt-param       to tt_ped_exec_param.tta_raw_param_ped_exec.

    ASSIGN i-cont-aux = 0.
    FOR EACH tt-raw-digita NO-LOCK: 
         ASSIGN i-cont-aux = i-cont-aux + 1.
         CREATE tt_ped_exec_param_aux.
         ASSIGN tt_ped_exec_param_aux.tta_num_dwb_order      = i-cont-aux
                tt_ped_exec_param_aux.tta_num_seq            = 1
                tt_ped_exec_param_aux.tta_raw_param_ped_exec = tt-raw-digita.raw-digita.
    END.

    RUN btb/btb912zb.p (INPUT-OUTPUT TABLE tt_param_segur,
                        INPUT-OUTPUT TABLE tt_ped_exec,
                        INPUT TABLE tt_ped_exec_param,
                        INPUT TABLE tt_ped_exec_param_aux,
                        INPUT TABLE tt_ped_exec_sel).

    FIND FIRST tt_ped_exec NO-LOCK NO-ERROR.
    IF AVAIL tt_ped_exec THEN DO:
         IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE("Cenci 5 " + STRING(tt_ped_exec.tta_num_ped_exec)).
    END.

      
   IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE("Cenci 6 ").
           
END PROCEDURE.

PROCEDURE pi-verifica-registro:
       
    IF msg0072.idm                              = ? THEN ASSIGN msg0072.idm                              = 0. 
    IF msg0072.CodigoConta                      = ? THEN ASSIGN msg0072.CodigoConta                      = "".
    IF msg0072.CodigoCliente                    = ? THEN ASSIGN msg0072.CodigoCliente                    = 0. 
    IF msg0072.ContaPrimaria                    = ? THEN ASSIGN msg0072.ContaPrimaria                    = "".
    IF msg0072.NomeRazaoSocial                  = ? THEN ASSIGN msg0072.NomeRazaoSocial                  = "".
    IF msg0072.NomeFantasia                     = ? THEN ASSIGN msg0072.NomeFantasia                     = "".
    IF msg0072.NomeAbreviado                    = ? THEN ASSIGN msg0072.NomeAbreviado                    = "".
    IF msg0072.DescricaoConta                   = ? THEN ASSIGN msg0072.DescricaoConta                   = "".
    IF msg0072.TipoRelacao                      = ? THEN ASSIGN msg0072.TipoRelacao                      = 0. 
    IF msg0072.NumeroBanco                      = ? THEN ASSIGN msg0072.NumeroBanco                      = 0.
    IF msg0072.NumeroAgencia                    = ? THEN ASSIGN msg0072.NumeroAgencia                    = "".
    IF msg0072.NumeroContaCorrente              = ? THEN ASSIGN msg0072.NumeroContaCorrente              = "".
    IF msg0072.EmiteBloqueto                    = ? THEN ASSIGN msg0072.EmiteBloqueto                    = NO.
    IF msg0072.GeraAvisoCredito                 = ? THEN ASSIGN msg0072.GeraAvisoCredito                 = NO.
    IF msg0072.CalculaMulta                     = ? THEN ASSIGN msg0072.CalculaMulta                     = NO.
    IF msg0072.RecebeInformacaoSCI              = ? THEN ASSIGN msg0072.RecebeInformacaoSCI              = NO.
    IF msg0072.Telefone                         = ? THEN ASSIGN msg0072.Telefone                         = "".
    IF msg0072.Ramal                            = ? THEN ASSIGN msg0072.Ramal                            = "".
    IF msg0072.TelefoneAlternativo              = ? THEN ASSIGN msg0072.TelefoneAlternativo              = "".
    IF msg0072.RamalTelefoneAlternativo         = ? THEN ASSIGN msg0072.RamalTelefoneAlternativo         = "".
    IF msg0072.Fax                              = ? THEN ASSIGN msg0072.Fax                              = "".
    IF msg0072.RamalFax                         = ? THEN ASSIGN msg0072.RamalFax                         = "".
    IF msg0072.Email                            = ? THEN ASSIGN msg0072.Email                            = "".
    IF msg0072.Site                             = ? THEN ASSIGN msg0072.Site                             = "".
    IF msg0072.Natureza                         = ? THEN ASSIGN msg0072.Natureza                         = 0.
    IF msg0072.CNPJ                             = ? THEN ASSIGN msg0072.CNPJ                             = "".
    IF msg0072.InscricaoEstadual                = ? THEN ASSIGN msg0072.InscricaoEstadual                = "".
    IF msg0072.InscricaoMunicipal               = ? THEN ASSIGN msg0072.InscricaoMunicipal               = "".
    IF msg0072.SuspensaoCredito                 = ? THEN ASSIGN msg0072.SuspensaoCredito                 = NO.
    IF msg0072.LimiteCredito                    = ? THEN ASSIGN msg0072.LimiteCredito                    = 0.
    /*IF msg0072.DataLimiteCredito                = ? THEN ASSIGN msg0072.DataLimiteCredito                = "".*/
    IF msg0072.SaldoCredito                     = ? THEN ASSIGN msg0072.SaldoCredito                     = 0.
    IF msg0072.ModalidadeCobranca               = ? THEN ASSIGN msg0072.ModalidadeCobranca               = 0.
    IF msg0072.ContribuinteICMS                 = ? THEN ASSIGN msg0072.ContribuinteICMS                 = NO.
    IF msg0072.CodigoSUFRAMA                    = ? THEN ASSIGN msg0072.CodigoSUFRAMA                    = "".
    IF msg0072.InscricaoSubstituicaoTributaria  = ? THEN ASSIGN msg0072.InscricaoSubstituicaoTributaria  = "".
    IF msg0072.OptanteSuspensaoIPI              = ? THEN ASSIGN msg0072.OptanteSuspensaoIPI              = NO.
    IF msg0072.AgenteRetencao                   = ? THEN ASSIGN msg0072.AgenteRetencao                   = NO.
    IF msg0072.PisCofinsUnidade                 = ? THEN ASSIGN msg0072.PisCofinsUnidade                 = NO.
    IF msg0072.RecebeNotaFiscalEletronica       = ? THEN ASSIGN msg0072.RecebeNotaFiscalEletronica       = NO.
    IF msg0072.FormaTributacao                  = ? THEN ASSIGN msg0072.FormaTributacao                  = 0.
    IF msg0072.ObservacaoPedido                 = ? THEN ASSIGN msg0072.ObservacaoPedido                 = "".
    IF msg0072.TipoEmbalagem                    = ? THEN ASSIGN msg0072.TipoEmbalagem                    = "".
    IF msg0072.CodigoIncoterm                   = ? THEN ASSIGN msg0072.CodigoIncoterm                   = "".
    IF msg0072.LocalEmbarque                    = ? THEN ASSIGN msg0072.LocalEmbarque                    = "".
    IF msg0072.ViaEmbarque                      = ? THEN ASSIGN msg0072.ViaEmbarque                      = "".
    /*IF msg0072.DataImplantacao                  = ? THEN ASSIGN msg0072.DataImplantacao                  = "".*/
    IF msg0072.CPF                              = ? THEN ASSIGN msg0072.CPF                              = "".
    IF msg0072.RG                               = ? THEN ASSIGN msg0072.RG                               = "".
    IF msg0072.OrgaoExpeditor                   = ? THEN ASSIGN msg0072.OrgaoExpeditor                   = "".
    /*IF msg0072.DataVencimentoConcessao          = ? THEN ASSIGN msg0072.DataVencimentoConcessao          = "".*/
    IF msg0072.DescontoAssistenciaTecnica       = ? THEN ASSIGN msg0072.DescontoAssistenciaTecnica       = 0.
    IF msg0072.CoberturaGeografica              = ? THEN ASSIGN msg0072.CoberturaGeografica              = "".
    /*IF msg0072.DataConstituicao                 = ? THEN ASSIGN msg0072.DataConstituicao                 = "".*/
    IF msg0072.DistribuicaoUnicaFonteReceita    = ? THEN ASSIGN msg0072.DistribuicaoUnicaFonteReceita    = NO.
    IF msg0072.DistribuidorPrincipal            = ? THEN ASSIGN msg0072.DistribuidorPrincipal            = "".
    IF msg0072.QualificadoTreinamento           = ? THEN ASSIGN msg0072.QualificadoTreinamento           = "".
    IF msg0072.Exclusividade                    = ? THEN ASSIGN msg0072.Exclusividade                    = NO.
    IF msg0072.Historico                        = ? THEN ASSIGN msg0072.Historico                        = "".
    IF msg0072.IntencaoApoio                    = ? THEN ASSIGN msg0072.IntencaoApoio                    = "".
    IF msg0072.MetodoComercializacao            = ? THEN ASSIGN msg0072.MetodoComercializacao            = "".
    IF msg0072.ModeloOperacao                   = ? THEN ASSIGN msg0072.ModeloOperacao                   = "".
    IF msg0072.NumeroFuncionarios               = ? THEN ASSIGN msg0072.NumeroFuncionarios               = 0.
    IF msg0072.NumeroColaboradoresAreaTecnica   = ? THEN ASSIGN msg0072.NumeroColaboradoresAreaTecnica   = 0.
    IF msg0072.NumeroRevendasAtivas             = ? THEN ASSIGN msg0072.NumeroRevendasAtivas             = 0.
    IF msg0072.NumeroRevendasInativas           = ? THEN ASSIGN msg0072.NumeroRevendasInativas           = "".
    IF msg0072.NumeroTecnicosSuporte            = ? THEN ASSIGN msg0072.NumeroTecnicosSuporte            = 0.
    IF msg0072.NumeroVendedores                 = ? THEN ASSIGN msg0072.NumeroVendedores                 = 0.
    IF msg0072.OutraFonteReceita                = ? THEN ASSIGN msg0072.OutraFonteReceita                = "".
    IF msg0072.ParticipaProgramaCanais          = ? THEN ASSIGN msg0072.ParticipaProgramaCanais          = 0.
    IF msg0072.PerfilRevendasDistribuidor       = ? THEN ASSIGN msg0072.PerfilRevendasDistribuidor       = "".
    IF msg0072.PossuiEstruturaCompleta          = ? THEN ASSIGN msg0072.PossuiEstruturaCompleta          = 0.
    IF msg0072.PossuiFiliais                    = ? THEN ASSIGN msg0072.PossuiFiliais                    = 0.
    IF msg0072.QuantidadeFiliais                = ? THEN ASSIGN msg0072.QuantidadeFiliais                = 0.
    IF msg0072.PrazoMedioCompra                 = ? THEN ASSIGN msg0072.PrazoMedioCompra                 = 0.
    IF msg0072.PrazoMedioVenda                  = ? THEN ASSIGN msg0072.PrazoMedioVenda                  = 0.
    IF msg0072.Setor                            = ? THEN ASSIGN msg0072.Setor                            = 0.
    IF msg0072.RamoAtividadeEconomica           = ? THEN ASSIGN msg0072.RamoAtividadeEconomica           = "".
    IF msg0072.SistemaGestao                    = ? THEN ASSIGN msg0072.SistemaGestao                    = "".
    IF msg0072.ValorMedioCompra                 = ? THEN ASSIGN msg0072.ValorMedioCompra                 = 0.
    IF msg0072.ValorMedioVenda                  = ? THEN ASSIGN msg0072.ValorMedioVenda                  = 0.
    IF msg0072.VendeAtacadista                  = ? THEN ASSIGN msg0072.VendeAtacadista                  = NO.
    IF msg0072.ListaPreco                       = ? THEN ASSIGN msg0072.ListaPreco                       = "".
    IF msg0072.ObservacaoNotaFiscal             = ? THEN ASSIGN msg0072.ObservacaoNotaFiscal             = "".
    IF msg0072.EstruturaPropriedade             = ? THEN ASSIGN msg0072.EstruturaPropriedade             = 0.
    IF msg0072.ReceitaAnual                     = ? THEN ASSIGN msg0072.ReceitaAnual                     = 0.
    IF msg0072.CNAE                             = ? THEN ASSIGN msg0072.CNAE                             = "".
    IF msg0072.Situacao                         = ? THEN ASSIGN msg0072.Situacao                         = 0.
    IF msg0072.Classificacao                    = ? THEN ASSIGN msg0072.Classificacao                    = "".
    IF msg0072.SubClassificacao                 = ? THEN ASSIGN msg0072.SubClassificacao                 = "".
    IF msg0072.Portador                         = ? THEN ASSIGN msg0072.Portador                         = 0.
    IF msg0072.NivelPosVenda                    = ? THEN ASSIGN msg0072.NivelPosVenda                    = "".
    IF msg0072.ReceitaPadrao                    = ? THEN ASSIGN msg0072.ReceitaPadrao                    = 0.
    IF msg0072.TransportadoraRedespacho         = ? THEN ASSIGN msg0072.TransportadoraRedespacho         = 0.
    IF msg0072.ContatoPrincipal                 = ? THEN ASSIGN msg0072.ContatoPrincipal                 = "".
    IF msg0072.Regiao                           = ? THEN ASSIGN msg0072.Regiao                           = "".
    /*IF msg0072.Transportadora                   = ? THEN ASSIGN msg0072.Transportadora                   = 0.*/
    IF msg0072.ApuracaoBeneficio                = ? THEN ASSIGN msg0072.ApuracaoBeneficio                = 0.
    IF msg0072.TipoConstituicao                 = ? THEN ASSIGN msg0072.TipoConstituicao                 = 0.
    IF msg0072.NumeroDiasAtraso                 = ? THEN ASSIGN msg0072.NumeroDiasAtraso                 = 0.
    IF msg0072.ClientePotencialOriginador       = ? THEN ASSIGN msg0072.ClientePotencialOriginador       = "".
    IF msg0072.CondicaoPagamento                = ? THEN ASSIGN msg0072.CondicaoPagamento                = 0.
    IF msg0072.Proprietario                     = ? THEN ASSIGN msg0072.Proprietario                     = "".
    IF msg0072.TipoProprietario                 = ? THEN ASSIGN msg0072.TipoProprietario                 = "".
    IF msg0072.TipoConta                        = ? THEN ASSIGN msg0072.TipoConta                        = 0.
    IF msg0072.CodigoCRM4                       = ? THEN ASSIGN msg0072.CodigoCRM4                       = "".
    /*IF msg0072.DataAdesao                       = ? THEN ASSIGN msg0072.DataAdesao                       = "".*/
    IF msg0072.CodigoEstrangeiro                = ? THEN ASSIGN msg0072.CodigoEstrangeiro                = "".
    IF msg0072.OrigemConta                      = ? THEN ASSIGN msg0072.OrigemConta                      = 0.
    IF msg0072.NumeroPassaporte                 = ? THEN ASSIGN msg0072.NumeroPassaporte                 = "".
    IF msg0072.StatusIntegracaoSefaz            = ? THEN ASSIGN msg0072.StatusIntegracaoSefaz            = 0.
    /*IF msg0072.DataHoraIntegracaoSefaz          = ? THEN ASSIGN msg0072.DataHoraIntegracaoSefaz          = "".*/
    IF msg0072.RegimeApuracao                   = ? THEN ASSIGN msg0072.RegimeApuracao                   = "".
    /*IF msg0072.DataBaixaContribuinte            = ? THEN ASSIGN msg0072.DataBaixaContribuinte            = "".*/
    /*IF msg0072.AssistenciaTecnica               = ? THEN ASSIGN msg0072.AssistenciaTecnica               = NO.*/
    IF msg0072.PerfilAssistenciaTecnica         = ? THEN ASSIGN msg0072.PerfilAssistenciaTecnica         = 0.
    IF msg0072.TabelaPrecoAssistenciaTecnica    = ? THEN ASSIGN msg0072.TabelaPrecoAssistenciaTecnica    = 0.
    IF msg0072.NomeAbreviadoMatrizEconomica     = ? THEN ASSIGN msg0072.NomeAbreviadoMatrizEconomica     = "".
    IF msg0072.AtualizadoIntegracao             = ? THEN ASSIGN msg0072.AtualizadoIntegracao             = NO.
    IF msg0072.CodigoRamoAtividadeEconomica     = ? THEN ASSIGN msg0072.CodigoRamoAtividadeEconomica     = "".
    IF msg0072.FiguraNoSite                     = ? THEN ASSIGN msg0072.FiguraNoSite                     = NO.
    IF msg0072.ParticipaProgramaCanaisMotivo    = ? THEN ASSIGN msg0072.ParticipaProgramaCanaisMotivo    = 0.
    IF msg0072.AdesaoPciRealizadaPor            = ? THEN ASSIGN msg0072.AdesaoPciRealizadaPor            = "".
    IF msg0072.EscolheuDistrForaSellOut         = ? THEN ASSIGN msg0072.EscolheuDistrForaSellOut         = NO.
    /*IF msg0072.DataUltimoSellOut                = ? THEN ASSIGN msg0072.DataUltimoSellOut                = "".*/
    IF msg0072.Categoria                        = ? THEN ASSIGN msg0072.Categoria                        = "".
    IF msg0072.CodigoCanalVenda                 = ? THEN ASSIGN msg0072.CodigoCanalVenda                 = 0.
    IF msg0072.IdentificacaoConta               = ? THEN ASSIGN msg0072.IdentificacaoConta               = 0.
    /*IF msg0072.CodigoRepresentante              = ? THEN ASSIGN msg0072.CodigoRepresentante              = 0.*/
    IF EnderecoPrincipal.idm                    = ? THEN ASSIGN EnderecoPrincipal.idm                    = 0.
    IF EnderecoPrincipal.NomeEndereco           = ? THEN ASSIGN EnderecoPrincipal.NomeEndereco           = "".
    IF EnderecoPrincipal.TipoEndereco           = ? THEN ASSIGN EnderecoPrincipal.TipoEndereco           = 0.
    IF EnderecoPrincipal.CaixaPostal            = ? THEN ASSIGN EnderecoPrincipal.CaixaPostal            = "".
    IF EnderecoPrincipal.CEP                    = ? THEN ASSIGN EnderecoPrincipal.CEP                    = "".
    IF EnderecoPrincipal.Logradouro             = ? THEN ASSIGN EnderecoPrincipal.Logradouro             = "".
    IF EnderecoPrincipal.Numero                 = ? THEN ASSIGN EnderecoPrincipal.Numero                 = "".
    IF EnderecoPrincipal.Complemento            = ? THEN ASSIGN EnderecoPrincipal.Complemento            = "".
    IF EnderecoPrincipal.Bairro                 = ? THEN ASSIGN EnderecoPrincipal.Bairro                 = "".
    IF EnderecoPrincipal.NomeCidade             = ? THEN ASSIGN EnderecoPrincipal.NomeCidade             = "".
    IF EnderecoPrincipal.Cidade                 = ? THEN ASSIGN EnderecoPrincipal.Cidade                 = "".
    IF EnderecoPrincipal.UF                     = ? THEN ASSIGN EnderecoPrincipal.UF                     = "".
    IF EnderecoPrincipal.Estado                 = ? THEN ASSIGN EnderecoPrincipal.Estado                 = "".
    IF EnderecoPrincipal.NomePais               = ? THEN ASSIGN EnderecoPrincipal.NomePais               = "".
    IF EnderecoPrincipal.Pais                   = ? THEN ASSIGN EnderecoPrincipal.Pais                   = "".
    IF EnderecoPrincipal.NomeContato            = ? THEN ASSIGN EnderecoPrincipal.NomeContato            = "".
    IF EnderecoPrincipal.Telefone               = ? THEN ASSIGN EnderecoPrincipal.Telefone               = "".
    IF EnderecoPrincipal.Fax                    = ? THEN ASSIGN EnderecoPrincipal.Fax                    = "".

    IF  AVAIL EnderecoCobranca THEN DO:
        IF EnderecoCobranca.idm                     = ? THEN ASSIGN EnderecoCobranca.idm                     = 0.
        IF EnderecoCobranca.NomeEndereco            = ? THEN ASSIGN EnderecoCobranca.NomeEndereco            = "".
        IF EnderecoCobranca.TipoEndereco            = ? THEN ASSIGN EnderecoCobranca.TipoEndereco            = 0.
        IF EnderecoCobranca.CaixaPostal             = ? THEN ASSIGN EnderecoCobranca.CaixaPostal             = "".
        IF EnderecoCobranca.CEP                     = ? THEN ASSIGN EnderecoCobranca.CEP                     = "".
        IF EnderecoCobranca.Logradouro              = ? THEN ASSIGN EnderecoCobranca.Logradouro              = "".
        IF EnderecoCobranca.Numero                  = ? THEN ASSIGN EnderecoCobranca.Numero                  = "".
        IF EnderecoCobranca.Complemento             = ? THEN ASSIGN EnderecoCobranca.Complemento             = "".
        IF EnderecoCobranca.Bairro                  = ? THEN ASSIGN EnderecoCobranca.Bairro                  = "".
        IF EnderecoCobranca.NomeCidade              = ? THEN ASSIGN EnderecoCobranca.NomeCidade              = "".
        IF EnderecoCobranca.Cidade                  = ? THEN ASSIGN EnderecoCobranca.Cidade                  = "".
        IF EnderecoCobranca.UF                      = ? THEN ASSIGN EnderecoCobranca.UF                      = "".
        IF EnderecoCobranca.Estado                  = ? THEN ASSIGN EnderecoCobranca.Estado                  = "".
        IF EnderecoCobranca.NomePais                = ? THEN ASSIGN EnderecoCobranca.NomePais                = "".
        IF EnderecoCobranca.Pais                    = ? THEN ASSIGN EnderecoCobranca.Pais                    = "".
        IF EnderecoCobranca.NomeContato             = ? THEN ASSIGN EnderecoCobranca.NomeContato             = "".
        IF EnderecoCobranca.Telefone                = ? THEN ASSIGN EnderecoCobranca.Telefone                = "".
        IF EnderecoCobranca.Fax                     = ? THEN ASSIGN EnderecoCobranca.Fax                     = "".
    END.

END PROCEDURE.



PROCEDURE pi-valida-caracter:

    DEFINE INPUT PARAM pCampo AS INT NO-UNDO. /*1 - razao social, 2 - Nome fantasia*/

    DEFINE VARIABLE caracter-1 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE caracter-2 AS CHARACTER   NO-UNDO.

    ASSIGN caracter-1 = 'Œ'. /*Hifen word*/
           caracter-2 = '-'. /*Hifen normal*/

    IF pCampo = 1 THEN DO:
       IF  INDEX(msg0072.NomeRazaoSocial,CHR(150)) > 0 THEN /* Retirar caracter especial */
           ASSIGN msg0072.NomeRazaoSocial = REPLACE(msg0072.NomeRazaoSocial,chr(ASC(caracter-1)),chr(ASC(caracter-2))).
    END.
    ELSE DO:
         IF  INDEX(msg0072.NomeFantasia,CHR(150)) > 0 THEN /* Retirar caracter especial */
              ASSIGN msg0072.NomeFantasia = REPLACE(msg0072.NomeFantasia,chr(ASC(caracter-1)),chr(ASC(caracter-2))).
    END.


END PROCEDURE.

