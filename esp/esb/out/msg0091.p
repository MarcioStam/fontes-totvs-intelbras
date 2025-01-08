CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-ped-venda LIKE ped-venda.

DEFINE VARIABLE de-frete-item           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-st             AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-tot-valor-st         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-val-ipi           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-endereco              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua                   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro                   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp                  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-cdapi704              AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-valor-merc-aberto    AS DECIMAL     NO-UNDO.
DEFINE BUFFER b-emitente FOR emitente.
DEFINE BUFFER b-int-emitente FOR int-emitente.

{esp/esb/out/msg0091.i}
{utp/ut-glob.i}
{include/i-freeac.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

RAW-TRANSFER raw-param TO tt-ped-venda.

FIND FIRST emitente NO-LOCK
     WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-ERROR.

FIND FIRST int-emitente NO-LOCK
    WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

IF  tt-ped-venda.cod-priori = 44 THEN RETURN.
IF  int-emitente.cod-guid = "" THEN RETURN.
IF NOT CAN-FIND(FIRST ped-item OF tt-ped-venda NO-LOCK) THEN NEXT.

FOR EACH ped-item OF tt-ped-venda NO-LOCK:
    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.
    
    /** Ignora notas de entrada **/
    IF  AVAIL natur-oper 
    AND natur-oper.tipo = 1 THEN DO:
    
        IF OPSYS = "UNIX" THEN 
            LOG-MANAGER:WRITE-MESSAGE("Pedido n∆o enviado! Ignora pedido de entrada").
        RETURN.
    END.
    
    /** Ignora notas que nío geram faturamento **/
/*     IF  AVAIL natur-oper                                         RETIRADO CONFORME CHAMADO 54506                                                                                   */
/*     AND NOT natur-oper.atual-estat THEN DO:                                                                                                                                        */
/*                                                                                                                                                                                    */
/*         /* Pedidos com origem de solicitac‰es de beneficio (bonificaá∆o) n∆o precisam gerar faturamento neste momento, pois a natureza ser† alterado posteriormente pelo usu†rio*/ */
/*         IF  tt-ped-venda.origem <> 9                                                                                                                                               */
/*         AND tt-ped-venda.origem <> 12 THEN DO:                                                                                                                                     */
/*             IF OPSYS = "UNIX" THEN                                                                                                                                                 */
/*                 LOG-MANAGER:WRITE-MESSAGE("Pedido n∆o enviado! Ignora pedido que nío geram faturamento").                                                                          */
/*             RETURN.                                                                                                                                                                */
/*         END.                                                                                                                                                                       */
/*     END.                                                                                                                                                                           */
    
END.

/*******************/

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' for cabecalho, conteudo, msg0091, EnderecoEntrega, EnderecoCobranca, ItensPedidos, msg0091-1, EnderecoEntregaIt
   DATA-RELATION FOR conteudo, msg0091            RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0091, EnderecoEntrega     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0091, EnderecoCobranca    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0091, ItensPedidos        RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ItensPedidos, msg0091-1      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0091-1, EnderecoEntregaIt RELATION-FIELDS (idm, idm) NESTED.

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0091r, resultado
   DATA-RELATION FOR conteudor, msg0091r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0091r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF"
       cabecalho.CodigoMensagem    = "MSG0091"
       cabecalho.LoginUsuario      = c-seg-usuario.

CREATE conteudo.
CREATE resultado.

FIND FIRST ped-venda NO-LOCK 
     WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.

FIND FIRST repres NO-LOCK
     WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.

FIND FIRST int-ped-venda NO-LOCK
     WHERE int-ped-venda.cod-estabel = ped-venda.cod-estabel
       AND int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

FIND FIRST transporte NO-LOCK
     WHERE transporte.nome-abrev = ped-venda.nome-transp NO-ERROR.

FIND FIRST b-emitente NO-LOCK
    WHERE b-emitente.nome-abrev = ped-venda.nome-abrev-tri NO-ERROR.

FIND FIRST b-int-emitente NO-LOCK
    WHERE b-int-emitente.cod-emitente = b-emitente.cod-emitente NO-ERROR.

FIND FIRST gr-cli-class-canal NO-LOCK
         WHERE gr-cli-class-canal.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.

FIND FIRST usuar_mestre 
    WHERE  usuar_mestre.cod_usuario = ped-venda.user-impl NO-LOCK NO-ERROR.

ASSIGN cabecalho.NumeroOperacao = STRING(ped-venda.nr-pedcli).

CREATE msg0091.                          
ASSIGN msg0091.NumeroPedido              = ped-venda.nr-pedido                             
       msg0091.Nome                      = STRING(ped-venda.nr-pedcli)                             
       msg0091.NumeroPedidoCliente       = IF SUBSTRING(int-ped-venda.char-1, 53, 12) = "" THEN "0" ELSE SUBSTRING(int-ped-venda.char-1, 53, 12)
       msg0091.NumeroPedidoRepresentante = ped-venda.nr-pedrep                
       msg0091.CodigoClienteCRM          = int-emitente.cod-guid
       msg0091.NomeAbreviadoCliente      = ped-venda.Nome-abrev                    
       msg0091.TabelaPreco               = "" /*informado pelo JosÇ que n∆o precisa mais, passar 0*/
       msg0091.TabelaPrecoEMS            = ""
       msg0091.Estabelecimento           = ped-venda.cod-estabel                        
       msg0091.CondicaoPagamento         = IF ped-venda.cod-cond-pag = 0 THEN ? ELSE ped-venda.cod-cond-pag
       msg0091.TabelaFinanciamento       = ped-venda.nr-tab-finan                   
       msg0091.Representante             = repres.cod-rep
       msg0091.CodigoAssistente          = ped-venda.tp-pedido
       msg0091.CodigoSupervisorEMS       = IF substring(int-ped-venda.char-1,68,8) = "" OR substring(int-ped-venda.char-1,68,8) = ? THEN ? ELSE substring(int-ped-venda.char-1,68,8)
       msg0091.NaturezaOperacao          = ped-venda.nat-operacao                      
       msg0091.DataEmissao               = ped-venda.dt-emissao                             
       msg0091.DataImplantacao           = ped-venda.dt-implant                         
       msg0091.UsuarioImplantacao        = ped-venda.user-impl
       msg0091.DataImplantacaoUsuario    = ped-venda.dt-userimp                  
       msg0091.DataEntrega               = ped-venda.dt-entrega                             
       msg0091.DataEntregaSolicitada     = ped-venda.dt-entorig                     
       msg0091.DataMinimaFaturamento     = ped-venda.dt-minfat                    
       msg0091.DataLimiteFaturamento     = ped-venda.dt-lim-fat                   
       msg0091.DataCumprimento           = ? 
       msg0091.DataReativacao            = ped-venda.dt-reativ                           
       msg0091.DataReativacaoUsuario     = ped-venda.dt-userrea                   
/*        msg0091.DataNegociacao            = int-ped-venda.dt-negociacao   */
/*        msg0091.DiasNegociacao            = int-ped-venda.dias-negociacao */
       msg0091.TipoPedido                = ped-venda.tp-pedido                               
       msg0091.Prioridade                = ped-venda.cod-priori                              
       msg0091.InscricaoEstadual         = replace(replace(replace(ped-venda.ins-estadual,'.',''),'-',''),'/','') 
       msg0091.Situacao                  = ped-venda.cod-sit-ped                         
       msg0091.PercentualDesconto1       = round(ped-venda.perc-desco1,2)                    
       msg0091.PercentualDesconto2       = round(ped-venda.perc-desco2,2)                    
       msg0091.CidadeCIF                 = ped-venda.cidade-cif                               
       msg0091.Portador                  = ped-venda.cod-portador                              
       msg0091.ModalidadeCobranca        = ped-venda.modalidade                              
       msg0091.Mensagem                  = ped-venda.cod-mensagem                              
       msg0091.Observacao                = fnConverteChar(SUBSTRING(ped-venda.observacoes,1,2000))
       msg0091.CondicaoEspecial          = fnConverteChar(SUBSTRING(ped-venda.cond-espec,1,2000))
       msg0091.ObservacaoRedespacho      = fnConverteChar(ped-venda.cond-redespa)
       msg0091.UsuarioAlteracao          = ped-venda.user-alte                         
       msg0091.DataAlteracao             = ped-venda.dt-useralt                           
       msg0091.UsuarioCancelamento       = ped-venda.user-canc                      
       msg0091.DescricaoCancelamento     = fnConverteChar(ped-venda.desc-cancela)
       msg0091.DataCancelamento          = ped-venda.dt-cancel                         
       msg0091.DataCancelamentoUsuario   = ped-venda.dt-usercan                 
       msg0091.UsuarioReativacao         = ped-venda.user-reat                        
       msg0091.UsuarioSuspensao          = ped-venda.user-suspen                       
       msg0091.DescricaoSuspensao        = string(fnConverteChar(ped-venda.desc-suspend),'x(2000)')
       msg0091.DataSuspensao             = ped-venda.dt-suspensao                         
       msg0091.IndicacaoAprovacao        = ped-venda.ind-aprov                       
       msg0091.AprovacaoForcada          = ped-venda.desc-forc-cr
       msg0091.UsuarioAprovacao          = SUBSTRING(ped-venda.quem-aprovou,1,12)
       msg0091.DataAprovacao             = ped-venda.dt-apr-cred                                                  
       msg0091.Transportadora            = IF AVAIL transporte THEN transporte.cod-transp ELSE ?
       msg0091.NomeTransportadora        = IF AVAIL transporte THEN transporte.nome ELSE ?
       msg0091.Rota                      = ped-venda.cod-rota                                      
       msg0091.FaturamentoParcial        = ped-venda.ind-fat-par                     
       msg0091.Moeda                     = "Real":U
       msg0091.ValorTotalLiquido         = round(ped-venda.vl-liq-ped,4)                       
       msg0091.ValorTotalPedido          = round(ped-venda.vl-tot-ped,4)                        
       msg0091.ValorTotalAberto          = round(ped-venda.vl-liq-abe,4)                        
       msg0091.IndiceFinanciamento       = IF ped-venda.nr-ind-finan = 0 THEN ? ELSE string(ped-venda.nr-tab-finan) + ";" + string(ped-venda.nr-ind-finan)                   
       msg0091.MotivoBloqueioCredito     = fnConverteChar(ped-venda.desc-bloq-cr)
       msg0091.MotivoLiberacaoCredito    = fnConverteChar(ped-venda.desc-forc-cr)
       msg0091.ValorCreditoLiberado      = round(ped-venda.vl-cred-lib,4)                   
       msg0091.ValorDesconto             = round(ped-venda.vl-desconto,4)                               
       msg0091.PercentualDescontoICMS    = round(ped-venda.per-des-icms,2)                
       msg0091.CodigoEntrega             = ped-venda.cod-entrega                          
       msg0091.ValorFrete                = round(int-ped-venda.vl-frete,4)                            
       msg0091.CondicaoFrete             = IF SUBSTRING(ped-venda.char-2,109,8) = "1" THEN 1 ELSE 2
       msg0091.PedidoCompleto            = ped-venda.completo                            
       msg0091.CanalVenda                = IF ped-venda.cod-canal-venda <> 0 THEN ped-venda.cod-canal-venda ELSE 8                         
       msg0091.ClienteTriangular         = IF AVAIL b-int-emitente THEN IF b-int-emitente.cod-guid = "" THEN ? ELSE b-int-emitente.cod-guid ELSE ?
       msg0091.CodigoEntregaTriangular   = ped-venda.cod-entrega-tri 
       msg0091.ListaPreco                = "Lista Padr∆o"
       msg0091.Descricao                 = ""
       msg0091.ValorTotalSemFrete        = round(ped-venda.vl-tot-ped - int-ped-venda.vl-frete,4)
       msg0091.ValorTotalDesconto        = round(ped-venda.val-desconto-total,4)
       msg0091.CampanhaOrigem            = ?
       msg0091.PrecoBloqueado            = NO
       msg0091.Classificacao             = IF AVAIL gr-cli-class-canal THEN IF gr-cli-class-canal.codigo-classificacao = "" THEN ? ELSE gr-cli-class-canal.codigo-classificacao ELSE ?
       msg0091.PedidoOriginal            = string(int-ped-venda.pedido-original)
       msg0091.Oportunidade              = ?
       msg0091.Proprietario              = IF int-emitente.proprietario <> "" THEN int-emitente.proprietario ELSE ?
       msg0091.TipoProprietario          = IF int-emitente.tipo-proprietario <> "" THEN int-emitente.tipo-proprietario ELSE ?
       msg0091.FormaPagamento            = ?
       msg0091.Cotacao                   = ?
       msg0091.CondicaoFreteEntrega      = 1
       msg0091.RetiraNoLocal             = NO
       msg0091.NomeUsuarioCriacao        = IF SUBSTRING(int-ped-venda.char-1,100,100) = "" THEN usuar_mestre.nom_usuario ELSE trim(SUBSTRING(int-ped-venda.char-1,100,100))
       msg0091.TipoUsuarioCriacao        = IF SUBSTRING(int-ped-venda.char-1,201,10)  = "" THEN 993520004 ELSE INTEGER(SUBSTRING(int-ped-venda.char-1,201,10)).


/*     MESSAGE "msg0091.NumeroPedido               " msg0091.NumeroPedido               SKIP              */
/*             "msg0091.Nome                       " msg0091.Nome                       SKIP              */
/*             "msg0091.NumeroPedidoCliente        " msg0091.NumeroPedidoCliente        SKIP              */
/*             "msg0091.NumeroPedidoRepresentante  " msg0091.NumeroPedidoRepresentante  SKIP              */
/*             " msg0091.CondicaoFreteEntrega      "  msg0091.CondicaoFreteEntrega      SKIP              */
/*             " msg0091.RetiraNoLocal             "  msg0091.RetiraNoLocal             SKIP              */
/*             " msg0091.NomeUsuarioCriacao        "  msg0091.NomeUsuarioCriacao        SKIP              */
/*             " msg0091.TipoUsuarioCriacao        "  msg0091.TipoUsuarioCriacao        SKIP              */
/*             " SUBSTRING(int-ped-venda.char-1,100,100)   " SUBSTRING(int-ped-venda.char-1,100,100) SKIP */
/*             " SUBSTRING(int-ped-venda.char-1,201,10)    " SUBSTRING(int-ped-venda.char-1,201,10)  SKIP */
/*             " usuar_mestre.nom_usuario                  " usuar_mestre.nom_usuario                     */
/*                                                                                                        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                             */
       
IF OPSYS = "UNIX" THEN DO:
    LOG-MANAGER:WRITE-MESSAGE("0091 ped-venda.nome-abrev: " + ped-venda.nome-abrev).    
    LOG-MANAGER:WRITE-MESSAGE("0091 ped-venda.nr-pedcli: " + ped-venda.nr-pedcli).
END.

/* VINCULAR A SOLICITAÄ«O, CASO EXISTE */  
FOR FIRST int-solicitacao-item FIELDS (CodigoSolicitacaoBeneficio) NO-LOCK
    WHERE int-solicitacao-item.nome-abrev    = ped-venda.nome-abrev
      AND int-solicitacao-item.nr-pedcli     = ped-venda.nr-pedcli
      AND NOT int-solicitacao-item.log-historica:

    ASSIGN msg0091.CodigoSolicitacaoBeneficio = int-solicitacao-item.CodigoSolicitacaoBeneficio.

    IF OPSYS = "UNIX" THEN DO:
        LOG-MANAGER:WRITE-MESSAGE("0091 int-solicitacao-item.CodigoSolicitacaoBeneficio: " + int-solicitacao-item.CodigoSolicitacaoBeneficio).
        LOG-MANAGER:WRITE-MESSAGE("0091 CodigoSolicitacaoBeneficio: " + msg0091.CodigoSolicitacaoBeneficio).
    END.


END.

IF  NOT AVAIL int-solicitacao-item THEN
    ASSIGN msg0091.CodigoSolicitacaoBeneficio = ?.

ASSIGN msg0091.TipoObjetoCliente = "account".     

IF ped-venda.cod-sit-ped = 1 THEN /*Aberto*/            
   ASSIGN msg0091.SituacaoPedido = "1"
          msg0091.Situacao       = 0. /*Ativa*/
ELSE IF ped-venda.cod-sit-ped = 2 THEN /*Atendido Parcial*/
    ASSIGN msg0091.SituacaoPedido = "993520001"
           msg0091.Situacao       = 0. /*Ativa*/
ELSE IF ped-venda.cod-sit-ped = 3 THEN /*Atendido Total*/
    ASSIGN msg0091.SituacaoPedido = "100001"
           msg0091.Situacao       = 3. /*Cumprido*/
ELSE IF ped-venda.cod-sit-ped = 4 THEN /*Pendente*/
    ASSIGN msg0091.SituacaoPedido = "2"
           msg0091.Situacao       = 0. /*Ativa*/
ELSE IF ped-venda.cod-sit-ped = 5 THEN /*Suspenso*/
    ASSIGN msg0091.SituacaoPedido = "993520000"
           msg0091.Situacao       = 0. /*Ativa*/
ELSE IF ped-venda.cod-sit-ped = 6 THEN /*Cancelado*/
    ASSIGN msg0091.SituacaoPedido = "4"
           msg0091.Situacao       = 2. /*Cancelada*/


IF ped-venda.modalidade = 6 THEN
    ASSIGN msg0091.ModalidadeCobranca = 993520006.
ELSE IF ped-venda.modalidade = 7 THEN
        ASSIGN msg0091.ModalidadeCobranca = 993520002.
     ELSE
         ASSIGN msg0091.ModalidadeCobranca = 993520000.

IF ped-venda.cod-sit-pre = 1 THEN
    ASSIGN msg0091.SituacaoAlocacao  = 993520000. /*N∆o Alocado*/  
ELSE IF ped-venda.cod-sit-pre = 2 THEN
    ASSIGN msg0091.SituacaoAlocacao  = 993520001. /*Alocado Parcial*/
ELSE 
    ASSIGN msg0091.SituacaoAlocacao  = 993520002. /*Alocado Total*/

IF ped-venda.cod-sit-aval = 1 THEN
    ASSIGN msg0091.SituacaoAvaliacao = 993520000. /*N∆o Avaliado*/
ELSE IF ped-venda.cod-sit-aval = 2 THEN
    ASSIGN msg0091.SituacaoAvaliacao = 993520001. /*Avaliado*/
ELSE IF ped-venda.cod-sit-aval = 3 THEN
    ASSIGN msg0091.SituacaoAvaliacao = 993520002. /*Aprovado*/
ELSE IF ped-venda.cod-sit-aval = 4 THEN
    ASSIGN msg0091.SituacaoAvaliacao = 993520003. /*N∆o Aprovado*/
ELSE 
    ASSIGN msg0091.SituacaoAvaliacao = 993520004. /*Pendente Informaá∆o*/

IF ped-venda.cod-des-merc = 1 THEN
    ASSIGN msg0091.DestinoMercadoria = 993520000. /*ComÇrcio / Ind£stria*/
ELSE 
    ASSIGN msg0091.DestinoMercadoria = 993520001. /*Cons Pr¢prio/Ativo*/

IF ped-venda.origem = 1 THEN
    ASSIGN msg0091.OrigemPedido = 993520010. /*Normal*/                                
ELSE IF ped-venda.origem = 2  THEN                                                     
    ASSIGN msg0091.OrigemPedido = 993520011. /*Tele Pedido*/                           
ELSE IF ped-venda.origem = 3  THEN                                                     
    ASSIGN msg0091.OrigemPedido = 993520012. /*Configurado*/                           
ELSE IF ped-venda.origem = 4  THEN                                                     
    ASSIGN msg0091.OrigemPedido = 993520013. /*Batch*/                                 
ELSE IF ped-venda.origem = 5  THEN                                                     
    ASSIGN msg0091.OrigemPedido = 993520014. /*Exportaá∆o*/                            
ELSE IF ped-venda.origem = 6  THEN                                                     
    ASSIGN msg0091.OrigemPedido = 993520015. /*EDI*/                                   
ELSE IF ped-venda.origem = 7  THEN                                                     
    ASSIGN msg0091.OrigemPedido = 993520000. /*Multiplanta*/                           
ELSE IF ped-venda.origem = 8  THEN                                                     
    ASSIGN msg0091.OrigemPedido = 993520001. /*Cotaá∆o*/                               
ELSE IF ped-venda.origem = 9  THEN                                                     
    ASSIGN msg0091.OrigemPedido = 993520002. /*Bonificaá∆o*/                           
ELSE IF ped-venda.origem = 10 THEN                                                     
    ASSIGN msg0091.OrigemPedido = 993520003. /*Portal Datasul*/
ELSE IF ped-venda.origem = 11 THEN
    ASSIGN msg0091.OrigemPedido = 993520004. /*SFA*/
ELSE IF ped-venda.origem = 12 THEN
    ASSIGN msg0091.OrigemPedido = 993520005. /*WEB*/
ELSE IF ped-venda.origem = 13 THEN
    ASSIGN msg0091.OrigemPedido = 993520006. /*B2B*/
ELSE IF ped-venda.origem = 14 THEN
    ASSIGN msg0091.OrigemPedido = 993520007. /*CRM*/
ELSE IF ped-venda.origem = 15 THEN
    ASSIGN msg0091.OrigemPedido = 993520008. /*CRM modificado no ERP*/
ELSE IF ped-venda.origem = 16 THEN
    ASSIGN msg0091.OrigemPedido = 993520009. /*EAI*/
ELSE IF ped-venda.origem = 17 THEN
    ASSIGN msg0091.OrigemPedido = 993520010. /*ASSIST*/.
    
IF ped-venda.tp-preco = 1 THEN
    ASSIGN msg0091.TipoPreco = 993520000. /*Preáo Informado*/
ELSE IF ped-venda.tp-preco = 2 THEN
    ASSIGN msg0091.TipoPreco = 993520001. /*Preáo Tabela Implantaá∆o*/
ELSE IF ped-venda.tp-preco = 3 THEN
    ASSIGN msg0091.TipoPreco = 993520002. /*Preáo Tabela Dia Faturamento*/
ELSE
    ASSIGN msg0091.TipoPreco = 0. /*???*/

IF emitente.natureza = 1 THEN
    ASSIGN msg0091.CPF                      = IF emitente.cgc <> "" THEN emitente.cgc ELSE ?
           msg0091.CNPJ                     = ?.
ELSE 
    ASSIGN msg0091.CNPJ                     = IF emitente.cgc <> "" THEN emitente.cgc ELSE ?
           msg0091.CPF                      = ?.

/*Chamado 98681*/
IF emitente.natureza >= 3 /*estrangeiro ou trading*/ THEN
    ASSIGN msg0091.CNPJ              = ?
           msg0091.CPF               = ?
           msg0091.InscricaoEstadual = ?.

IF emitente.natureza = 1 THEN
    ASSIGN msg0091.InscricaoEstadual = ?.

FIND FIRST unid-feder NO-LOCK
    WHERE unid-feder.estado = ped-venda.estado NO-ERROR.

FIND FIRST mgcad.pais NO-LOCK
    WHERE pais.nome-pais = ped-venda.pais NO-ERROR.

FIND int-loc-entr NO-LOCK
    WHERE int-loc-entr.nome-abrev  = ped-venda.nome-abrev
      AND int-loc-entr.cod-entrega = ped-venda.cod-entrega NO-ERROR.

FIND loc-entr NO-LOCK 
    WHERE loc-entr.nome-abrev  = ped-venda.nome-abrev 
      AND loc-entr.cod-entrega = ped-venda.cod-entrega NO-ERROR.                         

IF  AVAIL int-loc-entr 
AND int-loc-entr.endereco-completo <> "" THEN
    ASSIGN c-endereco = int-loc-entr.endereco-completo.
ELSE
    ASSIGN c-endereco = loc-entr.endereco.

ASSIGN c-rua      = ""
       c-nro      = ""
       c-comp     = "".

IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
    ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").

RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                     OUTPUT c-rua, 
                                     OUTPUT c-nro, 
                                     OUTPUT c-comp).

CREATE EnderecoEntrega.
ASSIGN EnderecoEntrega.NomeEndereco = fnConverteChar(ped-venda.local-entreg)
       EnderecoEntrega.TipoEndereco = 1
       EnderecoEntrega.CaixaPostal  = ""
       EnderecoEntrega.CEP          = string(int(ped-venda.cep),"99999999")
       EnderecoEntrega.Logradouro   = IF AVAIL int-loc-entr AND int-loc-entr.logradouro  <> "" THEN TRIM(SUBSTRING(int-loc-entr.logradouro,1,35))  ELSE string(c-rua,"X(35)")
       EnderecoEntrega.Numero       = IF AVAIL int-loc-entr AND int-loc-entr.numero      <> "" THEN int-loc-entr.numero      ELSE string(c-nro,"X(5)")
       EnderecoEntrega.Complemento  = IF AVAIL int-loc-entr AND int-loc-entr.complemento <> "" THEN TRIM(SUBSTRING(int-loc-entr.complemento,1,40)) ELSE SUBSTRING(c-comp,1,40)
       EnderecoEntrega.Bairro       = ped-venda.bairro                               
       EnderecoEntrega.NomeCidade   = ped-venda.cidade                               
       EnderecoEntrega.Cidade       = ped-venda.cidade + "," + ped-venda.estado + "," + pais.nome-pais
       EnderecoEntrega.UF           = ped-venda.estado                                   
       EnderecoEntrega.Estado       = pais.nome-pais + "," + ped-venda.estado                                   
       EnderecoEntrega.NomePais     = pais.nome-pais
       EnderecoEntrega.Pais         = pais.nome-pais
       EnderecoEntrega.NomeContato  = SUBSTRING(emitente.nome-emit,1,40)
       EnderecoEntrega.Telefone     = STRING(emitente.telefone[1],'X(15)')
       EnderecoEntrega.Fax          = STRING(emitente.telefax,'X(15)') .

ASSIGN c-endereco = emitente.endereco-cob.
ASSIGN c-rua      = ""
       c-nro      = ""
       c-comp     = "".

IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
    ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").


RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                     OUTPUT c-rua, 
                                     OUTPUT c-nro, 
                                     OUTPUT c-comp).
DELETE PROCEDURE h-cdapi704.
FIND FIRST unid-feder NO-LOCK
    WHERE unid-feder.estado = emitente.estado-cob NO-ERROR.

FIND FIRST pais NO-LOCK
    WHERE pais.nome-pais = emitente.pais-cob NO-ERROR.

CREATE EnderecoCobranca.
ASSIGN EnderecoCobranca.NomeEndereco = fnConverteChar(ped-venda.local-entreg)
       EnderecoCobranca.TipoEndereco = 1
       EnderecoCobranca.CaixaPostal  = ""
       EnderecoCobranca.CEP          = string(int(emitente.cep-cob),"99999999")                                      
       EnderecoCobranca.Logradouro   = IF AVAIL int-emitente AND int-emitente.logradouro-cob  <> "" THEN TRIM(SUBSTRING(int-emitente.logradouro-cob,1,35))  ELSE string(c-rua,"X(35)")
       EnderecoCobranca.Numero       = IF AVAIL int-emitente AND int-emitente.numero-cob      <> "" THEN int-emitente.numero-cob      ELSE string(c-nro,"X(5)") 
       EnderecoCobranca.Complemento  = IF AVAIL int-emitente AND int-emitente.complemento-cob <> "" THEN TRIM(SUBSTRING(int-emitente.complemento-cob,1,40)) ELSE SUBSTRING(c-comp,1,40)               
       EnderecoCobranca.Bairro       = emitente.bairro-cob                               
       EnderecoCobranca.NomeCidade   = emitente.cidade-cob                              
       EnderecoCobranca.Cidade       = emitente.cidade-cob + "," + emitente.estado-cob + "," + emitente.pais-cob                              
       EnderecoCobranca.UF           = emitente.estado-cob                                   
       EnderecoCobranca.Estado       = emitente.pais-cob + "," + emitente.estado-cob 
       EnderecoCobranca.NomePais     = emitente.pais-cob
       EnderecoCobranca.Pais         = emitente.pais-cob
       EnderecoCobranca.NomeContato  = SUBSTRING(emitente.nome-emit,1,40)
       EnderecoCobranca.Telefone     = STRING(emitente.telefone[1],'X(15)')
       EnderecoCobranca.Fax          = STRING(emitente.telefax,'X(15)') .

FOR EACH ped-item OF ped-venda NO-LOCK:
    FIND FIRST int-calculo-canal-item NO-LOCK
         WHERE int-calculo-canal-item.cod-guid     = int-emitente.cod-guid
           AND int-calculo-canal-item.cod-estabel  = ped-venda.cod-estabel
           AND int-calculo-canal-item.it-codigo    = ped-item.it-codigo
           AND int-calculo-canal-item.data-calculo = TODAY NO-ERROR.
    IF NOT AVAIL int-calculo-canal-item THEN DO:

        FIND FIRST ITEM
             WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
        FIND FIRST item-uni-estab
             WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
               AND item-uni-estab.it-codigo   = ped-item.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAIL ITEM THEN NEXT.
        IF NOT AVAIL item-uni-estab THEN NEXT.

        EMPTY TEMP-TABLE tt-itens.
        CREATE tt-itens.
        ASSIGN tt-itens.it-codigo              = ped-item.it-codigo
               tt-itens.de-quantidade          = ped-item.qt-pedida
               tt-itens.TipoPortfolio          = 993520005
               tt-itens.CodigoUnidadeNegocio   = item-uni-estab.cod-unid-neg
               tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
               tt-itens.CodigoEstabelecimento  = ped-venda.cod-estabel.
       
        RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                   INPUT  TABLE tt-itens,
                                   OUTPUT TABLE ProdutoItemR,
                                   OUTPUT TABLE Resultado).
       
        FIND FIRST ProdutoItemR NO-ERROR.
        FIND FIRST Resultado    NO-ERROR.
       
        IF  AVAIL Resultado THEN DO:
        
            IF Resultado.Sucesso THEN DO:
                FIND FIRST int-calculo-canal-item EXCLUSIVE-LOCK
                     WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                       AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel
                       AND int-calculo-canal-item.it-codigo   = ped-item.it-codigo NO-ERROR.
                IF AVAIL int-calculo-canal-item THEN DO:
                    ASSIGN int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                           int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                           int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                           int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                           int-calculo-canal-item.data-calculo           = TODAY.
                END.
                ELSE DO:
                    CREATE int-calculo-canal-item.
                    ASSIGN int-calculo-canal-item.cod-guid               = int-emitente.cod-guid   
                           int-calculo-canal-item.cod-estabel            = ped-venda.cod-estabel   
                           int-calculo-canal-item.it-codigo              = ProdutoItemR.CodigoProduto
                           int-calculo-canal-item.preco-base             = ProdutoItemR.PrecoBase
                           int-calculo-canal-item.valor-produto          = ProdutoItemR.ValorComDesconto
                           int-calculo-canal-item.tipo-portifolio        = 993520005
                           int-calculo-canal-item.bloqueado              = NO
                           int-calculo-canal-item.qtd-range              = ProdutoItemR.QuantidadeMaxima
                           int-calculo-canal-item.log-calcrebate         = ProdutoItemR.CalcularRebate            
                           int-calculo-canal-item.log-preco-alterado     = ProdutoItemR.PrecoAlterado             
                           int-calculo-canal-item.log-rebate-antec       = ProdutoItemR.RebateAntecipado          
                           int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                           int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                           int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado
                           int-calculo-canal-item.data-calculo           = TODAY.
                END.
                RELEASE int-calculo-canal-item.
            END.
        END.
    END.
END.

CREATE ItensPedidos.

ASSIGN de-valor-merc-aberto  = 0.
FOR EACH ped-item OF ped-venda NO-LOCK:
    RUN CriaItem (INPUT "A").
END.

FOR EACH int-ped-item-canais
   WHERE int-ped-item-canais.nr-pedcli = ped-venda.nr-pedcli NO-LOCK:

    RUN CriaItem (INPUT "E").
END.

CREATE EnderecoEntregaIt.
BUFFER-COPY EnderecoEntrega TO EnderecoEntregaIt.

ASSIGN msg0091.ValorTotalImpostos          = round(de-tot-valor-st + v-tot-val-ipi,4)
       msg0091.TotalSubstituicaoTributaria = round(de-tot-valor-st,4)
       msg0091.TotalIPI                    = round(v-tot-val-ipi,4)
       msg0091.ValorMercadoriaAberto       = round(de-valor-merc-aberto,4).

IF msg0091.CNPJ              = "" THEN ASSIGN msg0091.CNPJ = ?.
IF msg0091.CPF               = "" THEN ASSIGN msg0091.CPF  = ?.
IF msg0091.InscricaoEstadual = "" THEN ASSIGN msg0091.InscricaoEstadual = ?.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

/*  define variable hDoc    as handle   no-undo.                                                 */
/*  create x-document hDoc.                                                                      */
/*  hDoc:LOAD("longchar", oXML, NO).                                                             */
/*  hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */
/*                                                                                               */

FIND FIRST resultado NO-ERROR.

IF  AVAIL resultado
AND resultado.sucesso = YES THEN DO:
    FOR EACH int-ped-item-canais
       WHERE int-ped-item-canais.nr-pedcli = ped-venda.nr-pedcli EXCLUSIVE-LOCK:
        DELETE int-ped-item-canais.
    END.
END.

RETURN.

PROCEDURE CriaItem:
    DEFINE INPUT PARAM p-acao AS CHAR.
    DEFINE VARIABLE c-refer AS CHARACTER   NO-UNDO.

    IF p-acao = "E" THEN DO:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = int-ped-item-canais.it-codigo NO-ERROR.

        CREATE msg0091-1.                          
        ASSIGN msg0091-1.ChaveIntegracao              = string(ped-venda.cod-emitente) + "," + STRING(ped-venda.nr-pedido) + "," + STRING(int-ped-item-canais.nr-sequencia) + "," + int-ped-item-canais.it-codigo + "," + int-ped-item-canais.cod-refer
               msg0091-1.NumeroPedido                 = ped-venda.nr-pedido                     
               msg0091-1.NumeroPedidoCliente          = IF SUBSTRING(int-ped-venda.char-1, 53, 12) = "" THEN "0" ELSE SUBSTRING(int-ped-venda.char-1, 53, 12)
               msg0091-1.Sequencia                    = int-ped-item-canais.nr-sequencia                      
               msg0091-1.Produto                      = int-ped-item-canais.it-codigo                           
               msg0091-1.DescricaoItemPedido          = fnConverteChar(item.desc-item)
               msg0091-1.UnidadeMedida                = fn-free-accent(item.un)
               msg0091-1.DataImplantacao              = ped-venda.dt-implant                 
               msg0091-1.NomeAbreviadoCliente         = ped-venda.nome-abrev
               msg0091-1.Acao                         = p-acao
               msg0091-1.SituacaoAlocacao             = 993520000

               msg0091-1.SituacaoItem                 = 993520000

               msg0091-1.Moeda                        = "Real":U
               msg0091-1.UnidadeNegocio               = ITEM.cod-unid-negoc
               msg0091-1.NaturezaOperacao             = ped-venda.nat-operacao
               msg0091-1.Representante                = repres.cod-rep
               /*msg0091-1.CodigoSupervisorEMS       = substring(int-ped-venda.char-1,68,8)
               msg0091-1.CodigoAssistente          = ped-venda.tp-pedido*/
               msg0091-1.TipoPreco                    = 993520000        /*Preáo Informado*/

               msg0091-1.CondicaoFrete                = IF SUBSTRING(ped-venda.char-2,109,8) = "1" THEN 1 ELSE 2.

    END.
    ELSE DO:
        ASSIGN de-frete-item   = 0
               de-valor-st     = 0.
    
        FIND FIRST ITEM NO-LOCK
             WHERE item.it-codigo = ped-item.it-codigo NO-ERROR.
    
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.
    
        ASSIGN de-frete-item   = ROUND(int-ped-venda.vl-frete * (ped-item.qt-pedida - ped-item.qt-atendida) * ped-item.vl-preuni / ped-venda.vl-liq-ped ,2)
               de-valor-st     = ROUND(ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2)
               de-valor-merc-aberto = de-valor-merc-aberto + ped-item.vl-merc-abe.

        IF de-valor-st < 0 THEN
            ASSIGN de-valor-st = 0.

        IF ped-item.cod-sit-item <> 6 THEN
            ASSIGN de-tot-valor-st = de-tot-valor-st + de-valor-st
                   v-tot-val-ipi   = v-tot-val-ipi + ped-item.val-ipi.

        IF de-tot-valor-st < 0 THEN 
           ASSIGN de-tot-valor-st = 0.
    
        IF ped-item.cod-refer = ? THEN
            ASSIGN c-refer = "".
        ELSE 
            ASSIGN c-refer = ped-item.cod-refer.
        
        CREATE msg0091-1.                          
        ASSIGN msg0091-1.ChaveIntegracao              = string(ped-venda.cod-emitente) + "," + STRING(ped-venda.nr-pedido) + "," + STRING(ped-item.nr-sequencia) + "," + ped-item.it-codigo + "," + c-refer
               msg0091-1.NumeroPedido                 = ped-venda.nr-pedido                     
               msg0091-1.NumeroPedidoCliente          = IF SUBSTRING(int-ped-venda.char-1, 53, 12) = "" THEN "0" ELSE SUBSTRING(int-ped-venda.char-1, 53, 12)
               msg0091-1.Sequencia                    = ped-item.nr-sequencia                      
               msg0091-1.Produto                      = ped-item.it-codigo                           
               msg0091-1.DescricaoItemPedido          = fnConverteChar(item.desc-item)
               msg0091-1.UnidadeMedida                = fn-free-accent(item.un)
               msg0091-1.NaturezaOperacao             = ped-item.nat-operacao               
               msg0091-1.DataEntregaSolicitada        = ped-item.dt-entorig              
               msg0091-1.DataEntrega                  = ped-item.dt-entrega                      
               msg0091-1.DataImplantacao              = ped-venda.dt-implant                 
               msg0091-1.QuantidadePedida             = ped-item.qt-pedida                  
               msg0091-1.QuantidadeEntregue           = ped-item.qt-atendida             
               msg0091-1.QuantidadePendente           = ped-item.qt-pendente              
               msg0091-1.QuantidadeDevolvida          = ped-item.qt-devolvida            
               msg0091-1.QuantidadeCancelada          = IF ped-item.cod-sit-item = 6 THEN ped-item.qt-pedida - ped-item.qt-atendida ELSE 0
               msg0091-1.DataDevolucao                = ped-item.dt-devolucao                  
               msg0091-1.UsuarioDevolucao             = ped-item.user-devol
               msg0091-1.ValorTabela                  = round(ped-item.vl-pretab,4)                       
               msg0091-1.ValorOriginal                = round(ped-item.vl-preuni,4)                     
               msg0091-1.PrecoNegociado               = round(ped-item.vl-preuni,4)                     
               msg0091-1.PrecoMinimo                  = round(ped-item.per-minfat,4)                      
               msg0091-1.UsuarioImplantacao           = ped-item.user-impl                
               msg0091-1.UsuarioAlteracao             = ped-item.user-alte                  
               msg0091-1.DataAlteracao                = ped-item.dt-useralt                    
               msg0091-1.UsuarioCancelamento          = ped-item.user-canc               
               msg0091-1.DataCancelamentoSequencia    = ped-item.dt-canseq                  
               msg0091-1.DescricaoCancelamento        = fnConverteChar(ped-item.desc-cancela)
               msg0091-1.DataCancelamentoUsuario      = ped-item.dt-usercan         
               msg0091-1.UsuarioReativacao            = ped-item.user-reat                 
               msg0091-1.DataReativacao               = ped-item.dt-reativ                    
               msg0091-1.DataReativacaoUsuario        = ped-item.dt-userrea            
               msg0091-1.UsuarioSuspensao             = ped-item.user-susp                  
               msg0091-1.DataSuspensao                = ped-item.dt-suspensao                  
               msg0091-1.DataSuspensaoUsuario         = ped-item.dt-usersusp            
               msg0091-1.AliquotaIPI                  = round(ped-item.aliquota-ipi,2) 
               msg0091-1.RetemICMSFonte               = ped-item.ind-icm-ret                  
               msg0091-1.PercentualDescontoICMS       = 0 /**/
               msg0091-1.ValorLiquido                 = round(ped-item.vl-liq-it,4)                      
               msg0091-1.ValorLiquidoAberto           = round(ped-item.vl-liq-abe,4)               
               msg0091-1.ValorMercadoriaAberto        = round(ped-item.vl-merc-abe,4)               
               msg0091-1.ValorTotal                   = round(ped-item.vl-tot-it,4)                        
               msg0091-1.Observacao                   = fnConverteChar(substring(ped-item.observacao,1,2000))
               msg0091-1.QuantidadeAlocada            = ped-item.qt-alocada                
               msg0091-1.PercentualMinimoFaturamento  = 0 /**/
               msg0091-1.DataMaximaFaturamento        = ped-item.dt-max-fat            
               msg0091-1.DataMinimaFaturamento        = ped-item.dt-min-fat 
               msg0091-1.QuantidadeAlocadaLogica      = IF ped-item.qt-log-aloca < 0 THEN 0 ELSE ped-item.qt-log-aloca
               msg0091-1.PermiteSubstituirPreco       = YES /**/
               msg0091-1.FaturaQuantidadeFamilia      = ped-item.ind-fat-qtfam       
               msg0091-1.TaxaCambio                   = 0 /**/
               msg0091-1.DescontoManual               = ped-item.val-desconto-inform
               msg0091-1.CondicaoFrete                = IF SUBSTRING(ped-venda.char-2,109,8) = "1" THEN 1 ELSE 2
               msg0091-1.RetiraNoLocal                = NO /**/
               msg0091-1.ValorTotalImposto            = round(de-valor-st + ped-item.val-ipi,4)
               msg0091-1.ValorSubstituicaoTributaria  = round(de-valor-st,4)
               msg0091-1.ValorIPI                     = round(ped-item.val-ipi,4)
               msg0091-1.ProdutoForaCatalogo          = NO /**/         
               msg0091-1.DescricaoProdutoForaCatalogo = "" /**/
               msg0091-1.Moeda                        = "Real":U
               msg0091-1.UnidadeNegocio               = ped-item.cod-unid-negoc
               msg0091-1.Acao                         = p-acao
               msg0091-1.Representante                = repres.cod-rep                                 
               msg0091-1.NomeAbreviadoCliente         = ped-venda.nome-abrev
               msg0091-1.ValorTotalProduto            = ped-item.vl-tot-it.
        
        FIND FIRST int-ped-item-rebate
             WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev  
               AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli   
               AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
               AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo   
               AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer   NO-LOCK NO-ERROR.
        IF AVAIL int-ped-item-rebate THEN DO:

            FIND FIRST int-calculo-canal-item NO-LOCK
                 WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                   AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel
                   AND int-calculo-canal-item.it-codigo   = ped-item.it-codigo
                   AND int-calculo-canal-item.data-calculo = TODAY NO-ERROR.
            IF AVAIL int-calculo-canal-item THEN DO:
                IF int-ped-item-rebate.log-calcrebate         <> int-calculo-canal-item.log-calcrebate
                OR int-ped-item-rebate.perc-descto-verde      <> int-calculo-canal-item.perc-descto-verde        
                OR int-ped-item-rebate.perc-descto-top-milhao <> int-calculo-canal-item.perc-descto-top-milhao     
                OR int-ped-item-rebate.perc-rebate-antec      <> int-calculo-canal-item.perc-rebate-antec THEN DO:
                    FIND CURRENT int-ped-item-rebate EXCLUSIVE-LOCK NO-ERROR.
                    ASSIGN int-ped-item-rebate.log-calcrebate         = int-calculo-canal-item.log-calcrebate        
                           int-ped-item-rebate.perc-descto-verde      = int-calculo-canal-item.perc-descto-verde     
                           int-ped-item-rebate.perc-descto-top-milhao = int-calculo-canal-item.perc-descto-top-milhao
                           int-ped-item-rebate.perc-rebate-antec      = int-calculo-canal-item.perc-rebate-antec.
                    FIND CURRENT int-ped-item-rebate NO-LOCK NO-ERROR.
                END.
            END.

            ASSIGN msg0091-1.CalcularRebate              = int-ped-item-rebate.log-calcrebate
                   msg0091-1.PercentualDescontoVerde     = int-ped-item-rebate.perc-descto-verde      
                   msg0091-1.PercentualDescontoTopMilhao = int-ped-item-rebate.perc-descto-top-milhao  
                   msg0091-1.PercentualRebateAntecipado  = int-ped-item-rebate.perc-rebate-antec.
        END.

        IF ped-item.cod-sit-item = 1 THEN
            ASSIGN msg0091-1.SituacaoItem = 993520000. /*Aberto*/
        ELSE IF ped-item.cod-sit-item = 2 THEN
            ASSIGN msg0091-1.SituacaoItem = 993520001. /*Atendido Parcial*/
        ELSE IF ped-item.cod-sit-item = 3 THEN
            ASSIGN msg0091-1.SituacaoItem = 993520002. /*Atendido Total*/
        ELSE IF ped-item.cod-sit-item = 4 THEN
            ASSIGN msg0091-1.SituacaoItem = 993520003. /*Pendente*/
        ELSE IF ped-item.cod-sit-item = 5 THEN
            ASSIGN msg0091-1.SituacaoItem = 993520004. /*Suspenso*/
        ELSE IF ped-item.cod-sit-item = 6 THEN
            ASSIGN msg0091-1.SituacaoItem = 993520005. /*Cancelado*/
        ELSE 
            ASSIGN msg0091-1.SituacaoItem = 993520006. /*Fatur balc∆o*/
    
        IF ped-item.tp-preco = 1 THEN
            ASSIGN msg0091-1.TipoPreco = 993520000. /*Preáo Informado*/
        ELSE IF ped-item.tp-preco = 2 THEN
            ASSIGN msg0091-1.TipoPreco = 993520001. /*Preáo Tabela Implantaá∆o*/
        ELSE IF ped-item.tp-preco = 3 THEN
            ASSIGN msg0091-1.TipoPreco = 993520002. /*Preáo Tabela Dia Faturamento*/
        ELSE
            ASSIGN msg0091-1.TipoPreco = 0. /*???*/
    
        IF ped-item.cod-sit-pre = 1 THEN
            ASSIGN msg0091-1.SituacaoAlocacao  = 993520000. /*N∆o Alocado*/  
        ELSE IF ped-item.cod-sit-pre = 2 THEN
            ASSIGN msg0091-1.SituacaoAlocacao  = 993520001. /*Alocado Parcial*/
        ELSE 
            ASSIGN msg0091-1.SituacaoAlocacao  = 993520002. /*Alocado Total*/
    END.
END PROCEDURE.


