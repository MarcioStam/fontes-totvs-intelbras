USING Progress.Lang.*.
USING prmapi.Emitente FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS prmapi.NotaVendaIntegrador:
    
    {prmapi/XMLNotaFiscal.i}
    {prmapi/prmapi-nota-fiscal.i}
    {prmapi/prmapi-emitente.i}
    
    DEFINE VARIABLE c-arquivo-xml AS CHARACTER NO-UNDO.
               
    CONSTRUCTOR PUBLIC NotaVendaIntegrador(INPUT c-cod-proj-int AS CHARACTER):  
        
        FIND FIRST prm-param-integrador NO-LOCK NO-ERROR.
        IF NOT AVAIL prm-param-integrador THEN
            UNDO, THROW NEW Progress.Lang.AppError("ParÉmetros Gerais de Integraá∆o n∆o cadastrados. Verifique o programa PRM4102", 0).
        
        FIND FIRST prm-projeto-integrador NO-LOCK
             WHERE prm-projeto-integrador.cod-proj-int = c-cod-proj-int NO-ERROR.
        IF NOT AVAIL prm-projeto-integrador THEN
            UNDO, THROW NEW Progress.Lang.AppError(SUBSTITUTE("Projeto Integraá∆o informado &1 n∆o cadastrado. Verifique o programa PRM4103", c-cod-proj-int), 0).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO, THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1), erro:GetMessageNum(1)).
        END CATCH.        
    END CONSTRUCTOR.    

    METHOD PUBLIC ROWID GerarNFPeloArquivoXML(INPUT p-arquivo AS CHARACTER, INPUT p-tipo AS INTEGER): 
           
        DEFINE VARIABLE rw-nota-fiscal  AS ROWID        NO-UNDO.
        DEFINE VARIABLE c-erros         AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE l-ok            AS LOGICAL      NO-UNDO.
        
        ASSIGN c-arquivo-xml = p-arquivo.
                        
        FILE-INFO:FILE-NAME = c-arquivo-xml.
        IF FILE-INFO:FULL-PATHNAME = ? THEN
            UNDO,THROW NEW Progress.Lang.AppError("Arquivo " + c-arquivo-xml + " n∆o encontrado",0).
            
        ASSIGN l-ok = DATASET XMLNotaFiscal:READ-XML("file", c-arquivo-xml, "empty", ?, ?) NO-ERROR.        
        IF NOT l-ok THEN
            UNDO, THROW NEW Progress.Lang.AppError("XML da nota n∆o corresponde a uma sa°da v†lida", 0).
            
        ASSIGN rw-nota-fiscal = GetNFDoXML().
        IF rw-nota-fiscal <> ? THEN DO:
            
            FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = rw-nota-fiscal
                                   //AND   nota-fiscal.dt-cancela = ?
                                   NO-LOCK NO-ERROR.
            IF AVAILABLE(nota-fiscal) THEN DO:
                
                MoverXMLImportado(INPUT p-tipo).
                UNDO,THROW NEW Progress.Lang.AppError("Nota Fiscal " + nota-fiscal.nr-nota-fis + ",SÇrie " + nota-fiscal.serie + ",Estab " + nota-fiscal.cod-estabel + " j† gerada para o XML. Somente o arquivo XML ser† movido.",0).                
            END.                   
        END.           
         
        ASSIGN rw-nota-fiscal = ?
               rw-nota-fiscal = GerarNotaFiscal(INPUT p-tipo). 
         FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = rw-nota-fiscal
                               //AND   nota-fiscal.dt-cancela = ?
                               EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE(nota-fiscal) THEN DO:
        
            // Inicio alteraá‰es Intelbras - Jonatan da Mata - 29/09/23
            ASSIGN nota-fiscal.tp-pedido = "24"
                   nota-fiscal.nr-pedido = INT(nota-fiscal.nr-nota-fis)
                   nota-fiscal.nr-pedcli = nota-fiscal.nr-nota-fis
				   nota-fiscal.dt-saida  = nota-fiscal.dt-emis-nota.
            // Inicio alteraá‰es Intelbras - Jonatan da Mata - 29/09/23

            IF p-tipo = 3 /*3 - REMESSA*/ THEN DO:
                ASSIGN nota-fiscal.nome-transp = "RETIRA 104"
                       nota-fiscal.nr-pedcli = "".
            END.

            FIND FIRST int-nota-fiscal EXCLUSIVE-LOCK
                 WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel   
                 AND   int-nota-fiscal.serie       = nota-fiscal.serie         
                 AND   int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
                
            IF  NOT AVAIL int-nota-fiscal THEN DO:
                CREATE int-nota-fiscal.
                ASSIGN int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                       int-nota-fiscal.serie       = nota-fiscal.serie
                       int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis.
            END.

            IF NOT AVAIL emitente THEN
                FIND FIRST emitente WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.

            IF  AVAIL emitente THEN
                ASSIGN int-nota-fiscal.nome-emit  = emitente.nome-emit
                       int-nota-fiscal.cod-canal  = emitente.cod-canal-venda
                       int-nota-fiscal.cod-gr-cli = emitente.cod-gr-cli.

            FIND FIRST repres NO-LOCK
                 WHERE repres.nome-abrev = nota-fiscal.no-ab-reppri NO-ERROR.
            
            ASSIGN int-nota-fiscal.cod-atendente        = nota-fiscal.tp-pedido
                   OVERLAY(int-nota-fiscal.char-1,28,2) = nota-fiscal.tp-pedido
                   int-nota-fiscal.cod-rep              = IF AVAIL repres THEN repres.cod-rep ELSE 0
                   int-nota-fiscal.cod-supervisor       = 0.

            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido = nota-fiscal.nr-pedido NO-ERROR.
            IF  NOT AVAILABLE (int-ped-venda) THEN DO:
                CREATE int-ped-venda.
                ASSIGN int-ped-venda.nr-pedido = nota-fiscal.nr-pedido.
            END.

            FIND FIRST ttObsCont NO-ERROR.
            IF NOT AVAIL emitente THEN
                FIND FIRST emitente WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.
                
            FIND CURRENT int-ped-venda EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN int-ped-venda.cod-estabel            = nota-fiscal.cod-estabel
                   int-ped-venda.LojaCodigo             = 908
                   int-ped-venda.UsuarioCodigo          = 0
                   int-ped-venda.ContaCodigo            = emitente.cod-emitente
                   int-ped-venda.ContaCorrenteCodigo    = ""
                   int-ped-venda.GrupoCodigo            = 0
                   int-ped-venda.CupomCodigo            = 0
                   int-ped-venda.ParceiroCodigo         = 0
                   int-ped-venda.VitrineCodigo          = 0
                   int-ped-venda.ParcelamentoGCodigo    = 0
                   int-ped-venda.ParcelamentoPCodigo    = 0
                   int-ped-venda.ServicoEntregaCodigo   = 0
                   int-ped-venda.nr-parcelas            = 1
                   int-ped-venda.Score                  = 0
                   int-ped-venda.CestaCodigo            = ""
                   int-ped-venda.CestaMensagem          = ""
                   int-ped-venda.Sedex                  = ""
                   int-ped-venda.SedexData              = ?
                   int-ped-venda.MotivoCancel           = ""
                   int-ped-venda.Desconto               = 0
                   int-ped-venda.FormaPgto              = ""
                   int-ped-venda.ValorSubTotal          = 0
                   int-ped-venda.ValorParcela           = 0
                   int-ped-venda.ValorJuros             = 0
                   int-ped-venda.Mensagem               = ""
                   int-ped-venda.ValorFrete             = nota-fiscal.vl-frete
                   int-ped-venda.ValorPresente          = 0
                   int-ped-venda.PedidoStatus           = ""
                   int-ped-venda.StatusIntegracao       = ""
                   int-ped-venda.StatusClearSale        = ""
                   int-ped-venda.AvisoBoleto            = ""
                   int-ped-venda.FreteGratis            = ""
                   int-ped-venda.ValorVale              = 0
                   int-ped-venda.vl-frete               = nota-fiscal.vl-frete
                   int-ped-venda.pedidocodigo           = nota-fiscal.nr-pedido
                   int-ped-venda.reference-number       = IF AVAIL ttObsCont THEN ENTRY(3,ttObsCont.xTexto,"-") ELSE ""
                   int-ped-venda.tid                    = IF AVAIL ttObsCont THEN ENTRY(3,ttObsCont.xTexto,"-") ELSE ""
                   int-ped-venda.cartid                 = IF AVAIL ttObsCont THEN ENTRY(3,ttObsCont.xTexto,"-") ELSE "".
                   overlay(int-ped-venda.char-1,26,15)  = "".
            FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
            RELEASE int-ped-venda.    
            
            MoverXMLImportado(INPUT p-tipo).
        END.
        RELEASE nota-fiscal.
        RETURN rw-nota-fiscal.   
        
        CATCH erro AS Progress.Lang.Error :
            ASSIGN c-erros = erro:GetMessage(1).                                    
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).                  
        END CATCH.
        FINALLY:
            CriarLogNF(INPUT rw-nota-fiscal,
                       INPUT c-erros,
                       INPUT p-tipo).                                                              
                       
            IF c-erros <> "" THEN DO:
                EnviarEmailNFComErro(INPUT c-erros).    
            END.                                                                      
        END FINALLY.
    END METHOD.         

    METHOD PRIVATE ROWID GerarNotaFiscal(INPUT p-tipo AS INTEGER):      
                 
        DEFINE VARIABLE h-prmapi-nota-fiscal    AS HANDLE       NO-UNDO.
        DEFINE VARIABLE rw-nota-fiscal          AS ROWID        NO-UNDO.
        DEFINE VARIABLE c-erros                 AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-cgc                   AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE rw-emitente             AS ROWID        NO-UNDO.
        DEFINE VARIABLE i-nr-seq-fat            AS INTEGER      NO-UNDO.
        DEFINE VARIABLE i-nr-seq-parcela        AS INTEGER      NO-UNDO.
        DEFINE VARIABLE dt-emissao              AS DATE         NO-UNDO.
        DEFINE VARIABLE c-dhEmi                 AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-natur-oper            AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-nat-oper              AS CHAR         NO-UNDO.
        DEFINE VARIABLE l-return                AS LOG          NO-UNDO.
        DEFINE VARIABLE h-boes505               AS HANDLE       NO-UNDO.
        DEFINE VARIABLE c-compr-fabric          AS CHARACTER    NO-UNDO.
        
        EMPTY TEMP-TABLE tt-nota-fiscal.
        EMPTY TEMP-TABLE item-nota-fiscal.
        EMPTY TEMP-TABLE tt-fat-duplic.        
        EMPTY TEMP-TABLE tt-erro.
       
        ASSIGN rw-nota-fiscal = GetNFDoXML().
        IF rw-nota-fiscal <> ? THEN DO:
            
            FIND FIRST nota-fiscal NO-LOCK
                 WHERE ROWID(nota-fiscal) = rw-nota-fiscal
                   /*AND nota-fiscal.dt-cancela = ?*/ NO-ERROR.
            IF AVAILABLE(nota-fiscal) THEN
                UNDO, THROW NEW Progress.Lang.AppError("Nota Fiscal " + nota-fiscal.nr-nota-fis + ", SÇrie " + nota-fiscal.serie + ", Estab " + nota-fiscal.cod-estabel + " j† gerada para o XML", 0).                               
        END.                                     
        
        FOR FIRST ttInfNFe:

            FOR FIRST ttIde:       
                ASSIGN c-dhEmi    = SUBSTRING(ttIde.dhEmi,1,10)
                       dt-emissao = DATE(INTEGER(ENTRY(2,c-dhEmi,"-")),
                                    INTEGER(ENTRY(3,c-dhEmi,"-")),
                                    INTEGER(ENTRY(1,c-dhEmi,"-"))) NO-ERROR.
            END.
            ASSIGN dt-emissao = IF dt-emissao = ? THEN TODAY ELSE dt-emissao.

            ASSIGN rw-emitente = CadastrarClienteDoXML(INPUT dt-emissao).
            
            FIND FIRST emitente WHERE ROWID(emitente) = rw-emitente NO-LOCK NO-ERROR.        
            IF NOT AVAILABLE(emitente) THEN 
                UNDO,THROW NEW Progress.Lang.AppError(INPUT "Cliente n∆o localizado com CNPJ/CPF " + c-cgc,0).
        
            FOR FIRST ttEmit:
                FIND FIRST estabelec WHERE estabelec.cgc = ttEmit.CNPJ NO-LOCK NO-ERROR.
                IF NOT AVAILABLE(estabelec) THEN
                    UNDO,THROW NEW Progress.Lang.AppError(INPUT "Estabelecimento n∆o localizado com CNPJ " + ttEmit.CNPJ,0).
            END.                    
        
            FIND FIRST cond-pagto NO-LOCK
                 WHERE cond-pagto.cod-cond-pag = emitente.cod-cond-pag NO-ERROR.

            IF emitente.cod-cond-pag = 0 THEN
                FIND FIRST cond-pagto NO-LOCK
                     WHERE cond-pagto.cod-cond-pag = 1 NO-ERROR.

            FIND FIRST ser-estab NO-LOCK 
                 WHERE ser-estab.serie       = prm-projeto-integrador.serie
                   AND ser-estab.cod-estabel = estabelec.cod-estabel NO-ERROR.
            IF NOT AVAIL ser-estab THEN
                UNDO,THROW NEW Progress.Lang.AppError(INPUT SUBSTITUTE("SÇrie &1 n∆o encontrada para o estabelecimento &2. Consulte o programa FT0114", prm-projeto-integrador.serie, estabelec.cod-estabel), 0).

            CREATE tt-nota-fiscal.
            ASSIGN tt-nota-fiscal.cod-estabel     = estabelec.cod-estabel                                                  
                   tt-nota-fiscal.cod-emitente    = emitente.cod-emitente     

                   /* DAC - 18/12/2020 - Informaá‰es faltantes na nota fiscal. */
                   tt-nota-fiscal.cod-rep         = 2051 //emitente.cod-rep // Alteraá‰es Intelbras - Jonatan da Mata - 29/09/23
                   tt-nota-fiscal.cod-cond-pag    = IF AVAIL cond-pagto AND cond-pagto.cod-cond-pag <> 0 THEN cond-pagto.cod-cond-pag ELSE 1
                   tt-nota-fiscal.cod-portador    = emitente.portador // Alteraá‰es Intelbras - Jonatan da Mata - 29/09/23
                   tt-nota-fiscal.modalidade      = emitente.modalidade
                   tt-nota-fiscal.nr-tab-finan    = IF AVAIL cond-pagto THEN cond-pagto.nr-tab-finan ELSE 1
                   tt-nota-fiscal.nr-ind-finan    = IF AVAIL cond-pagto THEN cond-pagto.nr-ind-finan ELSE 0
                   tt-nota-fiscal.vl-taxa-exp     = 1
                   tt-nota-fiscal.tipo-nf         = 2                                 
                   tt-nota-fiscal.cod-canal-venda = 0               
                   tt-nota-fiscal.nr-tabpre       = ""       
                   tt-nota-fiscal.volumes         = 0        
                   tt-nota-fiscal.observacao      = "".
            
            FOR FIRST ttIde:       
                ASSIGN c-dhEmi    = SUBSTRING(ttIde.dhEmi,1,10)                                               
                       dt-emissao = DATE(INTEGER(ENTRY(2,c-dhEmi,"-")),
                                         INTEGER(ENTRY(3,c-dhEmi,"-")),
                                         INTEGER(ENTRY(1,c-dhEmi,"-"))) NO-ERROR.
                
                ASSIGN tt-nota-fiscal.serie        = prm-projeto-integrador.serie
                       tt-nota-fiscal.dt-emis-nota = dt-emissao                       
                       tt-nota-fiscal.nr-nota-fis  = ttIde.nNF
                       tt-nota-fiscal.nr-fatura    = ttIde.nNF
                       tt-nota-fiscal.cod-des-merc = INTEGER(ttIde.idDest).                
            END.
            
            FOR FIRST ttDest:
                ASSIGN tt-nota-fiscal.ins-estadual = ttDest.IE.    
            END.
            
            FOR FIRST ttEnderDest:

                IF LENGTH(ttEnderDest.xLgr) < 2 THEN
                    ASSIGN ttEnderDest.xLgr = "Rua " + ttEnderDest.xLgr.
                
                ASSIGN tt-nota-fiscal.estado   = ttEnderDest.UF
                       tt-nota-fiscal.pais     = ttEnderDest.xPais
                       tt-nota-fiscal.bairro   = ttEnderDest.xBairro
                       tt-nota-fiscal.cep      = ttEnderDest.CEP
                       tt-nota-fiscal.endereco = ttEnderDest.xLgr + "," + ttEnderDest.nro 
                       tt-nota-fiscal.cidade   = ttEnderDest.xMun.
            END.                                                              
            
            FOR FIRST ttVol:
                ASSIGN tt-nota-fiscal.nr-volumes   = ttVol.qVol
                       tt-nota-fiscal.peso-bru-tot = ttVol.pesoB
                       tt-nota-fiscal.peso-liq-tot = ttVol.pesoL.    
            END.
            
            FOR FIRST ttTransporta:
                FIND FIRST transporte WHERE transporte.cgc = ttTransporta.cnpj NO-LOCK NO-ERROR.
                IF AVAILABLE(transporte) THEN
                    ASSIGN tt-nota-fiscal.nome-transp = transporte.nome-abrev.    
            END.       
            
            /*IF tt-nota-fiscal.nome-transp = "" THEN DO:
                FIND FIRST transporte WHERE transporte.cod-transp = 3627 NO-LOCK NO-ERROR.
                IF AVAILABLE(transporte) THEN
                    ASSIGN tt-nota-fiscal.nome-transp = transporte.nome-abrev.
            END.*/
            
            IF tt-nota-fiscal.nome-transp = "" THEN DO:
                FIND FIRST transporte WHERE transporte.cod-transp = emitente.cod-transp NO-LOCK NO-ERROR.
                IF NOT AVAILABLE(transporte) THEN DO:
                    FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                    IF AVAIL gr-cli THEN
                        FIND FIRST transporte WHERE transporte.cod-transp = gr-cli.cod-transp NO-LOCK NO-ERROR.
                END.
                
                IF AVAIL transporte THEN
                    ASSIGN tt-nota-fiscal.nome-transp = transporte.nome-abrev.
            END.                         
            
            FOR FIRST ttFat:
                ASSIGN tt-nota-fiscal.nr-fatura = ttFat.nFat.    
            END.
            
            FOR FIRST ttICMSTot:                
                ASSIGN tt-nota-fiscal.vl-mercad = ttICMSTot.vProd
                       tt-nota-fiscal.vl-frete  = ttICMSTot.vFrete
					   tt-nota-fiscal.vl-desc-tot = ttICMSTot.vDesc.
            END.                      
            
            FOR EACH ttDet 
               WHERE ttDet.parent-id = RECID(ttInfNFe):
                
                FOR EACH ttProd
                   WHERE ttProd.parent-id = RECID(ttDet):
                    
                    /*--- Valida CFOP sa°da - Notas de remessa e venda dever∆o ter CFOP >= 5 ---*/
                    IF INTEGER(SUBSTRING(ttProd.CFOP, 1, 1)) < 5 THEN
                        UNDO,THROW NEW Progress.Lang.AppError(INPUT SUBSTITUTE("CFOP &1 da nota fiscal n∆o corresponde a uma nota de sa°da", ttProd.CFOP), 0).
                    /*--------------------------------------------------------------------------*/
                    
                    FIND FIRST item NO-LOCK
                         WHERE item.it-codigo = ttProd.cProd NO-ERROR.
                    IF NOT AVAILABLE(item) THEN
                        UNDO,THROW NEW Progress.Lang.AppError(INPUT "Item " + ttProd.cProd + " n∆o cadastrado no sistema.", 0).
                    
                    // Inicio Chamada Funá∆o
                    FIND FIRST funcao NO-LOCK
                         WHERE funcao.cd-funcao = 'spp-nat-oper'
                           AND funcao.ativo     = TRUE NO-ERROR.
                               
                    IF AVAIL funcao THEN DO:
                                   
                        //INICIALIZA BO
                        IF NOT VALID-HANDLE(h-boes505) THEN
                            RUN esbo/boes505.p PERSISTENT SET h-boes505.
                                
                            RUN defineNatOperacao IN h-boes505 (INPUT estabelec.cod-estabel, //Estab
                                                                INPUT emitente.cod-emitente, //Emitente
                                                                INPUT '',                    //Loc Entr
                                                                INPUT ITEM.it-codigo,        //Item
                                                                INPUT TRUE,                  //Consumidor Final
                                                                OUTPUT c-nat-oper,           //Nat Oper
                                                                OUTPUT l-return).            //Ret
                                                                
                        //FINALIZA BO
                        IF VALID-HANDLE(h-boes505) THEN
                            DELETE PROCEDURE h-boes505.
                                
                        IF l-return THEN
                                
                            ASSIGN c-natur-oper = c-nat-oper.
                                     
                        ELSE
                            MESSAGE "Natureza de operacao nao encontrada - Verifique o ESCDP015"
                                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                            
                    END.
                    ELSE DO:
                        /*segue fluxo atual*/

                        IF ITEM.compr-fabric = 1 THEN ASSIGN c-compr-fabric = "Comprado". ELSE ASSIGN c-compr-fabric = "Fabricado".

                        
                        /*
                            JONK
                            
                            prm-regras-integrador.cod-proj-int   = "ML"                 
                            prm-regras-integrador.cod-estabel    = tt-cfop.cfop         
                            prm-regras-integrador.fm-codigo      = tt-cfop.tipo         
                            prm-regras-integrador.estado         = tt-cfop.estado       
                            prm-regras-integrador.nat-oper-venda = tt-cfop.contribuinte 
                            prm-regras-integrador.it-codigo      = tt-cfop.it-codigo    
                            prm-regras-integrador.nat-oper-rem   = tt-cfop.origem-item  
                            prm-regras-integrador.nat-oper-ret   = tt-cfop.natureza     
                            prm-regras-integrador.nat-oper-dev   = ""                   
                            prm-regras-integrador.fm-cod-com     = ""
                            
                            */

                        /*--- Busca regra da natureza de operaá∆o ---*/

                        FIND FIRST   prm-regras-integrador NO-LOCK
                             WHERE   prm-regras-integrador.cod-proj-int     = prm-projeto-integrador.cod-proj-int
                               AND   prm-regras-integrador.cfop             = ttProd.CFOP
                               // 1. TODOS PREENCHIDOS
                               AND   prm-regras-integrador.estado           = emitente.estado       
                               AND   prm-regras-integrador.ind-contribuinte = IF emitente.contrib-icms THEN YES ELSE NO
                               AND   prm-regras-integrador.it-codigo        = ITEM.it-codigo NO-ERROR.
                        /*IF NOT AVAIL prm-regras-integrador THEN
                            FIND FIRST   prm-regras-integrador NO-LOCK
                                 WHERE   prm-regras-integrador.cod-proj-int     = prm-projeto-integrador.cod-proj-int
                                   AND   prm-regras-integrador.cfop             = ttProd.CFOP
                                   // 2. SEM CONTRIBUINTE
                                   AND   prm-regras-integrador.estado           = emitente.estado 
                                   //AND   prm-regras-integrador.ind-contribuinte = "*"
                                   AND   prm-regras-integrador.it-codigo        = ITEM.it-codigo NO-ERROR. */
                        IF NOT AVAIL prm-regras-integrador THEN
                            FIND FIRST   prm-regras-integrador NO-LOCK
                                 WHERE   prm-regras-integrador.cod-proj-int     = prm-projeto-integrador.cod-proj-int
                                   AND   prm-regras-integrador.cfop             = ttProd.CFOP
                                   // 3. SEM ESTADO E CONTRIBUINTE
                                   AND   prm-regras-integrador.estado           = "*"
                                   //AND   prm-regras-integrador.ind-contribuinte = "*"
                                   AND   prm-regras-integrador.it-codigo        = ITEM.it-codigo NO-ERROR.
                        IF NOT AVAIL prm-regras-integrador THEN
                            FIND FIRST   prm-regras-integrador NO-LOCK
                                 WHERE   prm-regras-integrador.cod-proj-int     = prm-projeto-integrador.cod-proj-int
                                   AND   prm-regras-integrador.cfop             = ttProd.CFOP
                                   // 4. SEM ESTADO, CONTRIBUINTE E ITEM
                                   AND   prm-regras-integrador.estado           = "*"
                                   //AND   prm-regras-integrador.ind-contribuinte = "*"
                                   AND   prm-regras-integrador.it-codigo        = "*" NO-ERROR.

                                /*
                        /*--- Busca regra da natureza de operaá∆o ---*/
                        FIND FIRST   prm-regras-integrador NO-LOCK
                             WHERE   prm-regras-integrador.cod-proj-int     = prm-projeto-integrador.cod-proj-int
                               AND   prm-regras-integrador.cod-estabel      = estabelec.cod-estabel
                               // 1. TODOS PREENCHIDOS
                               AND  (prm-regras-integrador.estado           = emitente.estado
                               AND   prm-regras-integrador.it-codigo        = ITEM.it-codigo)
                               AND   prm-regras-integrador.origem-item      = c-compr-fabric
                               AND   prm-regras-integrador.ind-contribuinte = emitente.contrib-icms NO-ERROR.
                        IF NOT AVAIL prm-regras-integrador THEN
                            FIND FIRST   prm-regras-integrador NO-LOCK
                                 WHERE   prm-regras-integrador.cod-proj-int     = prm-projeto-integrador.cod-proj-int
                                   AND   prm-regras-integrador.cod-estabel      = estabelec.cod-estabel
                                   // 2. COM ESTADO SEM ITEM
                                   AND  (prm-regras-integrador.estado           = emitente.estado
                                   AND  (prm-regras-integrador.it-codigo        = ?
                                    OR   prm-regras-integrador.it-codigo        = "?"))
                                   AND   prm-regras-integrador.origem-item      = c-compr-fabric
                                   AND   prm-regras-integrador.ind-contribuinte = emitente.contrib-icms NO-ERROR.
                        IF NOT AVAIL prm-regras-integrador THEN
                            FIND FIRST   prm-regras-integrador NO-LOCK
                                 WHERE   prm-regras-integrador.cod-proj-int     = prm-projeto-integrador.cod-proj-int
                                   AND   prm-regras-integrador.cod-estabel      = estabelec.cod-estabel
                                   // 3. COM ITEM SEM ESTADO
                                   AND  ((prm-regras-integrador.it-codigo        = ?
                                    OR   prm-regras-integrador.it-codigo        = "?")
                                   AND  (prm-regras-integrador.estado           = ?
                                    OR   prm-regras-integrador.estado           = "?"))
                                   AND   prm-regras-integrador.origem-item      = c-compr-fabric
                                   AND   prm-regras-integrador.ind-contribuinte = emitente.contrib-icms NO-ERROR.
                        IF NOT AVAIL prm-regras-integrador THEN
                            FIND FIRST   prm-regras-integrador NO-LOCK
                                 WHERE   prm-regras-integrador.cod-proj-int     = prm-projeto-integrador.cod-proj-int
                                   AND   prm-regras-integrador.cod-estabel      = estabelec.cod-estabel
                                   // 4. SEM ESTADO SEM ITEM
                                   AND  (prm-regras-integrador.it-codigo        = ITEM.it-codigo
                                   AND  (prm-regras-integrador.estado           = ?
                                    OR   prm-regras-integrador.estado           = "?"))
                                   AND   prm-regras-integrador.origem-item      = c-compr-fabric
                                   AND   prm-regras-integrador.ind-contribuinte = emitente.contrib-icms NO-ERROR.
                                   */
/*
                        IF NOT AVAIL prm-regras-integrador THEN
                            UNDO,THROW NEW Progress.Lang.AppError(INPUT SUBSTITUTE("Nenhuma regra de natureza de operaá∆o foi parametrizada para a chave Estado &1, Estab &2, Fam°lia Material &3, Fam°lia Comercial &4 Item &5. Verificar o programa PRM4103",
                                                                                   emitente.estado,
                                                                                   estabelec.cod-estabel,
                                                                                   item.fm-codigo,
                                                                                   item.fm-cod-com,
                                                                                   item.it-codigo), 0).
                                                                                   */

                        IF NOT AVAIL prm-regras-integrador THEN
                                UNDO,THROW NEW Progress.Lang.AppError(INPUT SUBSTITUTE("Nenhuma regra de natureza de operaá∆o foi parametrizada para a chave CFOP &1, Estado &2, Contribuinte &3, Item &4, Origem do Item &5. Verificar o programa PRM4103",
                                                                                       ttProd.CFOP,
                                                                                       emitente.estado,
                                                                                       STRING(emitente.contrib-icms,"Sim/Nao"),
                                                                                       ITEM.it-codigo,
                                                                                       c-compr-fabric), 0).
    
                        //ASSIGN c-natur-oper = IF p-tipo = 1 THEN prm-regras-integrador.nat-oper-venda ELSE IF p-tipo = 3 THEN prm-regras-integrador.nat-oper-rem ELSE "".
                        ASSIGN c-natur-oper = prm-regras-integrador.nat-operacao.
                    
                    END.
                        
                    IF NOT CAN-FIND(FIRST item-nota-fiscal NO-LOCK) THEN DO:
                        ASSIGN tt-nota-fiscal.nat-operacao = c-natur-oper.
                    END.

                    
                    
                    CREATE item-nota-fiscal.
                    ASSIGN i-nr-seq-fat                   = i-nr-seq-fat + 10
                           item-nota-fiscal.it-codigo     = ttProd.cProd
                           item-nota-fiscal.nr-seq-fat    = i-nr-seq-fat
                           item-nota-fiscal.nat-operacao  = c-natur-oper
                           item-nota-fiscal.cod-depos     = IF p-tipo = 1 THEN prm-projeto-integrador.cod-depos ELSE IF p-tipo = 3 THEN prm-projeto-integrador.cod-depos-saida ELSE ""
                           item-nota-fiscal.cod-localiz   = ""
                           item-nota-fiscal.qt-faturada   = ttProd.qCom
                           item-nota-fiscal.vl-merc-liq   = ttProd.vProd - ttProd.vDesc //ttProd.vUnCom
                           item-nota-fiscal.vl-merc-ori   = ttProd.vProd //ttProd.vUnCom
                           item-nota-fiscal.vl-merc-tab   = ttProd.vProd //ttProd.vUnCom
                           item-nota-fiscal.vl-preori-ped = ttProd.vUnCom
                           item-nota-fiscal.vl-pretab     = ttProd.vUnCom
                           item-nota-fiscal.vl-preuni     = ttProd.vUnCom
                           item-nota-fiscal.class-fiscal  = ttProd.NCM
                           item-nota-fiscal.un-fatur      = ttProd.uCom
                           item-nota-fiscal.cd-trib-iss   = 4
                           item-nota-fiscal.vl-frete      = ttProd.vFrete
                           item-nota-fiscal.vl-tot-item   = ttProd.vProd - ttProd.vDesc + item-nota-fiscal.vl-frete
                           item-nota-fiscal.vl-desconto   = ttProd.vDesc.

                    IF ttIde.natOp = "Outras Saidas - Remessa Simbolica para Deposito Temporario" THEN
                        ASSIGN item-nota-fiscal.cod-depos = prm-projeto-integrador.cod-depos.

                    IF ttIde.natOp = "Outras Saidas - Remessa para Deposito Temporario"
                    AND tt-nota-fiscal.estado <> "SC" THEN
                        ASSIGN item-nota-fiscal.cod-depos = prm-projeto-integrador.cod-depos.
                    
                    FOR FIRST ttRastro 
                        WHERE ttRastro.parent-id = RECID(ttProd):
                        
                        ASSIGN item-nota-fiscal.nr-serlote = ttRastro.nLote.                        
                        ASSIGN item-nota-fiscal.dt-vali-lote = DATE(INTEGER(ENTRY(2,ttRastro.dVal,"-")),        
                                                                    INTEGER(ENTRY(3,ttRastro.dVal,"-")),                     
                                                                    INTEGER(ENTRY(1,ttRastro.dVal,"-"))) NO-ERROR.
                    END.  

                    FIND FIRST natur-oper NO-LOCK 
                         WHERE natur-oper.nat-operacao = item-nota-fiscal.nat-operacao NO-ERROR.
                    IF NOT AVAILABLE(natur-oper) THEN 
                        UNDO,THROW NEW Progress.Lang.AppError(INPUT "Natureza de Operaá∆o " + item-nota-fiscal.nat-operacao + " n∆o cadastrada.",0).                                                          
                    
                    FIND FIRST ITEM NO-LOCK 
                         WHERE ITEM.it-codigo = item-nota-fiscal.it-codigo NO-ERROR.
                    IF NOT AVAILABLE(item) THEN 
                        UNDO,THROW NEW Progress.Lang.AppError(INPUT "Item " + item-nota-fiscal.it-codigo + " n∆o cadastrado.",0).

                    ASSIGN item-nota-fiscal.baixa-estoq = natur-oper.baixa-estoq.

                    /* DAC */
                    FIND FIRST ttImposto 
                         WHERE ttImposto.parent-id = RECID(ttDet) NO-ERROR.
                    
                    CASE natur-oper.cd-trib-icm:
                        /* TRIBUTADO */
                        WHEN 1 THEN DO:
                            CASE ITEM.cd-trib-icm:
                                WHEN 1 THEN ASSIGN item-nota-fiscal.cd-trib-icm = 1.
                                WHEN 2 THEN ASSIGN item-nota-fiscal.cd-trib-icm = 2.
                                WHEN 3 THEN ASSIGN item-nota-fiscal.cd-trib-icm = 3.
                                WHEN 4 THEN ASSIGN item-nota-fiscal.cd-trib-icm = 1.
                                WHEN 5 THEN ASSIGN item-nota-fiscal.cd-trib-icm = 5.
                            END CASE.
                        END.

                        /* ISENTO */
                        WHEN 2 THEN DO:
                            ASSIGN item-nota-fiscal.cd-trib-icm = 2.
                        END.

                        /* OUTROS */
                        WHEN 3 THEN DO:
                            ASSIGN item-nota-fiscal.cd-trib-icm = 3.
                        END.

                        /* REDUZIDO */
                        WHEN 4 THEN DO:
                            ASSIGN item-nota-fiscal.cd-trib-icm = ITEM.cd-trib-icm.
                        END.

                        /* DIFERIDO */
                        WHEN 5 THEN DO:
                            ASSIGN item-nota-fiscal.cd-trib-icm = 5.
                        END.
                    END CASE.
                    
                    FIND FIRST ttICMS 
                         WHERE ttICMS.parent-id = RECID(ttImposto) NO-ERROR.

                    FOR FIRST ttICMS00 
                        WHERE ttICMS00.parent-id = RECID(ttICMS):
                        ASSIGN item-nota-fiscal.aliquota-icm = ttICMS00.pICMS
                               item-nota-fiscal.vl-icms-it   = ttICMS00.vICMS
                               item-nota-fiscal.vl-bicms-it  = ttICMS00.vBC.    
                    END.

                    FOR FIRST ttICMS10 
                        WHERE ttICMS10.parent-id = RECID(ttICMS):
                        ASSIGN item-nota-fiscal.vl-bicms-it  = ttICMS10.vBC
                               item-nota-fiscal.aliquota-icm = ttICMS10.pICMS
                               item-nota-fiscal.vl-icms-it   = ttICMS10.vICMS
                               item-nota-fiscal.vl-bsubs-it  = ttICMS10.vBCST
                               item-nota-fiscal.pICMSST      = ttICMS10.pICMSST
                               item-nota-fiscal.vICMSST      = ttICMS10.vICMSST
                               item-nota-fiscal.vBCFCPST     = ttICMS10.vBCFCPST
                               item-nota-fiscal.pFCPST       = ttICMS10.pFCPST  
                               item-nota-fiscal.vFCPST       = ttICMS10.vFCPST  
                               item-nota-fiscal.vl-tot-item  = item-nota-fiscal.vl-tot-item + item-nota-fiscal.vICMSST + ttICMS10.vFCPST. 
                    END.

                    /*
                    MESSAGE item-nota-fiscal.vl-bicms-it  skip
                            item-nota-fiscal.aliquota-icm skip
                            item-nota-fiscal.vl-icms-it   skip
                            item-nota-fiscal.vl-bsubs-it 
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                        */
                    
                    FOR FIRST ttICMS20 
                        WHERE ttICMS20.parent-id = RECID(ttICMS):
                        ASSIGN item-nota-fiscal.aliquota-icm  = ttICMS20.pICMS
                               item-nota-fiscal.vl-icms-it    = ttICMS20.vICMS
                               item-nota-fiscal.vl-bicms-it   = ttICMS20.vBC
                               item-nota-fiscal.perc-red-icms = ttICMS20.pRedBC.
                               
                        IF p-tipo = 1 /*1 - VENDA*/ THEN
                            ASSIGN item-nota-fiscal.vl-icms-nt = ROUND(((item-nota-fiscal.vl-bicms-it * 100) / (100 - item-nota-fiscal.perc-red-icms)) - item-nota-fiscal.vl-bicms-it, 2). 
                        ELSE IF p-tipo = 3 /*3 - REMESSA*/ THEN
                            ASSIGN item-nota-fiscal.vl-icms-nt = ROUND((item-nota-fiscal.perc-red-icms / 100) * item-nota-fiscal.vl-tot-item, 2).    
                    END.
                    
                    FOR FIRST ttICMS51 
                        WHERE ttICMS51.parent-id = RECID(ttICMS):
                        ASSIGN item-nota-fiscal.aliquota-icm  = ttICMS51.pICMS
                               item-nota-fiscal.vl-icms-it    = ttICMS51.vICMS
                               item-nota-fiscal.vl-bicms-it   = ttICMS51.vBC
                               item-nota-fiscal.perc-red-icms = ttICMS51.pRedBC.
                               
                        IF p-tipo = 1 /*1 - VENDA*/ THEN
                            ASSIGN item-nota-fiscal.vl-icms-nt = ROUND(((item-nota-fiscal.vl-bicms-it * 100) / (100 - item-nota-fiscal.perc-red-icms)) - item-nota-fiscal.vl-bicms-it, 2). 
                        ELSE IF p-tipo = 3 /*3 - REMESSA*/ THEN
                            ASSIGN item-nota-fiscal.vl-icms-nt = ROUND((item-nota-fiscal.perc-red-icms / 100) * item-nota-fiscal.vl-tot-item, 2).   
                    END.
                    
                    FOR FIRST ttICMS70 
                        WHERE ttICMS70.parent-id = RECID(ttICMS):
                        ASSIGN item-nota-fiscal.aliquota-icm  = ttICMS70.pICMS
                               item-nota-fiscal.vl-icms-it    = ttICMS70.vICMS
                               item-nota-fiscal.vl-bicms-it   = ttICMS70.vBC
                               item-nota-fiscal.perc-red-icms = ttICMS70.pRedBC.
                               
                        IF p-tipo = 1 /*1 - VENDA*/ THEN
                            ASSIGN item-nota-fiscal.vl-icms-nt = ROUND(((item-nota-fiscal.vl-bicms-it * 100) / (100 - item-nota-fiscal.perc-red-icms)) - item-nota-fiscal.vl-bicms-it, 2). 
                        ELSE IF p-tipo = 3 /*3 - REMESSA*/ THEN
                            ASSIGN item-nota-fiscal.vl-icms-nt = ROUND((item-nota-fiscal.perc-red-icms / 100) * item-nota-fiscal.vl-tot-item, 2).  
                    END.
                    
                    FOR FIRST ttICMS90 
                        WHERE ttICMS90.parent-id = RECID(ttICMS):
                        ASSIGN item-nota-fiscal.aliquota-icm  = ttICMS90.pICMS
                               item-nota-fiscal.vl-icms-it    = ttICMS90.vICMS
                               item-nota-fiscal.vl-bicms-it   = ttICMS90.vBC
                               item-nota-fiscal.perc-red-icms = ttICMS90.pRedBC.
                               
                        IF p-tipo = 1 /*1 - VENDA*/ THEN
                            ASSIGN item-nota-fiscal.vl-icms-nt = ROUND(((item-nota-fiscal.vl-bicms-it * 100) / (100 - item-nota-fiscal.perc-red-icms)) - item-nota-fiscal.vl-bicms-it, 2). 
                        ELSE IF p-tipo = 3 /*3 - REMESSA*/ THEN
                            ASSIGN item-nota-fiscal.vl-icms-nt = ROUND((item-nota-fiscal.perc-red-icms / 100) * item-nota-fiscal.vl-tot-item, 2).  
                    END.
                    
                    /* DAC */                                                  
                    CASE natur-oper.cd-trib-ipi:
                        /* TRIBUTADO */
                        WHEN 1 THEN DO:
                            CASE ITEM.cd-trib-ipi:
                                WHEN 1 THEN ASSIGN item-nota-fiscal.cd-trib-ipi = 1.
                                WHEN 2 THEN ASSIGN item-nota-fiscal.cd-trib-ipi = 2.
                                WHEN 3 THEN ASSIGN item-nota-fiscal.cd-trib-ipi = 3.
                                WHEN 4 THEN ASSIGN item-nota-fiscal.cd-trib-ipi = 1.
                                WHEN 5 THEN ASSIGN item-nota-fiscal.cd-trib-ipi = 5.
                            END CASE.
                        END.

                        /* ISENTO */
                        WHEN 2 THEN DO:
                            ASSIGN item-nota-fiscal.cd-trib-ipi = 2.
                        END.

                        /* OUTROS */
                        WHEN 3 THEN DO:
                            ASSIGN item-nota-fiscal.cd-trib-ipi   = 3
                                   item-nota-fiscal.vl-ipi-outros = item-nota-fiscal.vl-tot-item.
                        END.

                        /* REDUZIDO */
                        WHEN 4 THEN DO:
                            ASSIGN item-nota-fiscal.cd-trib-ipi = ITEM.cd-trib-icm.
                        END.

                        /* DIFERIDO */
                        WHEN 5 THEN DO:
                            ASSIGN item-nota-fiscal.cd-trib-ipi = 5.
                        END.
                    END CASE.                   

                    FIND FIRST ttIPI 
                         WHERE ttIPI.parent-id = RECID(ttImposto) NO-ERROR.
                         
                    FOR FIRST ttIPITrib 
                        WHERE ttIPITrib.parent-id = RECID(ttIPI):
                        ASSIGN /*item-nota-fiscal.cd-trib-ipi  = INTEGER(ttIPITrib.CST)*/
                               item-nota-fiscal.vl-bipi-it   = ttIPITrib.vBC
                               item-nota-fiscal.aliquota-ipi = ttIPITrib.pIPI
                               item-nota-fiscal.vl-ipi-it    = ttIPITrib.vIPI.

                        /* DAC */
                        ASSIGN item-nota-fiscal.vl-tot-item = item-nota-fiscal.vl-tot-item + item-nota-fiscal.vl-ipi-it.
                    END.  

                    IF AVAILABLE(ttImposto) THEN DO:
                        
                        FOR FIRST ttICMSUFDest 
                            WHERE ttICMSUFDest.parent-id = RECID(ttImposto):
                                
                            ASSIGN item-nota-fiscal.vBCUFDest      = ttICMSUFDest.vBCUFDest     
                                   item-nota-fiscal.vBCFCPUFDest   = ttICMSUFDest.vBCFCPUFDest  
                                   item-nota-fiscal.pFCPUFDest     = ttICMSUFDest.pFCPUFDest    
                                   item-nota-fiscal.pICMSUFDest    = ttICMSUFDest.pICMSUFDest   
                                   item-nota-fiscal.pICMSInter     = ttICMSUFDest.pICMSInter    
                                   item-nota-fiscal.pICMSInterPart = ttICMSUFDest.pICMSInterPart
                                   item-nota-fiscal.vFCPUFDest     = ttICMSUFDest.vFCPUFDest    
                                   item-nota-fiscal.vICMSUFDest    = ttICMSUFDest.vICMSUFDest.                                    
                        END. 
                        
                        FOR FIRST ttPIS 
                            WHERE ttPIS.parent-id = RECID(ttImposto),
                            FIRST ttPISAliq 
                            WHERE ttPISAliq.parent-id = RECID(ttPIS):
                            
                            ASSIGN item-nota-fiscal.vl-base-pis = ttPISAliq.vBC
                                   item-nota-fiscal.perc-pis    = ttPISAliq.pPIS
                                   item-nota-fiscal.vl-pis      = ttPISAliq.vPIS.
                        END.
                        
                        FOR FIRST ttCOFINS 
                            WHERE ttCOFINS.parent-id = RECID(ttImposto),
                            FIRST ttCOFINSAliq 
                            WHERE ttCOFINSAliq.parent-id = RECID(ttCOFINS):
                            
                            ASSIGN item-nota-fiscal.vl-base-cofins = ttCOFINSAliq.vBC
                                   item-nota-fiscal.perc-cofins    = ttCOFINSAliq.pCOFINS
                                   item-nota-fiscal.vl-cofins      = ttCOFINSAliq.vCOFINS.
                        END.                                                      
                    END.
                    
/*                    IF IsItemIPIOutros(BUFFER item-nota-fiscal) THEN DO:                     */
/*                        ASSIGN item-nota-fiscal.cd-trib-ipi   = 3                            */
/*                               item-nota-fiscal.vl-ipi-outros = item-nota-fiscal.vl-tot-item.*/
/*                    END.                                                                     */
                END.                           
            END.                        

            FIND FIRST natur-oper NO-LOCK 
                 WHERE natur-oper.nat-operacao = tt-nota-fiscal.nat-operacao NO-ERROR.
            IF NOT AVAILABLE(natur-oper) THEN
                UNDO,THROW NEW Progress.Lang.AppError("Natureza de operaá∆o " + tt-nota-fiscal.nat-operacao + " n∆o cadastrada.",0).
            
            IF natur-oper.emite-duplic THEN DO:
                
                FOR FIRST ttCobr:                              
                    FIND FIRST ttFat WHERE ttFat.parent-id = RECID(ttCobr) NO-LOCK NO-ERROR.                                     
    
                    FOR EACH ttDup WHERE ttDup.parent-id = RECID(ttCobr):
                        CREATE tt-fat-duplic.
                        ASSIGN tt-fat-duplic.cod-estabel  = tt-nota-fiscal.cod-estabel
                               tt-fat-duplic.nr-fatura    = tt-nota-fiscal.nr-nota-fis
                               tt-fat-duplic.serie        = tt-nota-fiscal.serie
                               tt-fat-duplic.parcela      = '01'
                               tt-fat-duplic.cod-esp      = ser-estab.cod-esp
                               tt-fat-duplic.dt-venciment = DATE(INTEGER(ENTRY(2,ttDup.dVenc,"-")),
                                                                 INTEGER(ENTRY(3,ttDup.dVenc,"-")),
                                                                 INTEGER(ENTRY(1,ttDup.dVenc,"-")) ).
    
                        ASSIGN tt-fat-duplic.parcela    = ttDup.nDup
                               tt-fat-duplic.vl-parcela = ttDup.vDup.
                               
                        IF AVAILABLE(ttFat) THEN                           
                            ASSIGN tt-fat-duplic.vl-acum-dup = ttFat.vLiq.
                    END.  
                END. 
    
                /* DAC */
                IF NOT CAN-FIND (FIRST tt-fat-duplic) THEN DO:
                    
                    ASSIGN i-nr-seq-parcela = 1.
                    
                    FOR EACH ttdetPag:

                        CREATE tt-fat-duplic.
                        ASSIGN tt-fat-duplic.dt-venciment = TODAY + 15
                               tt-fat-duplic.parcela      = STRING(i-nr-seq-parcela, "99")
                               tt-fat-duplic.cod-esp      = ser-estab.cod-esp
        
                               tt-fat-duplic.cod-estabel = tt-nota-fiscal.cod-estabel
                               tt-fat-duplic.nr-fatura   = tt-nota-fiscal.nr-nota-fis
                               tt-fat-duplic.serie       = tt-nota-fiscal.serie
        
                               tt-fat-duplic.vl-parcela   = ttdetPag.vPag
                               tt-fat-duplic.vl-acum-dup  = ttdetPag.vPag.
                               
                        ASSIGN i-nr-seq-parcela = i-nr-seq-parcela + 1.
                    END.
                END.
            END.

            FIND FIRST ttProtNFE 
                 WHERE ttProtNFE.parent-id = RECID(ttnfe) NO-ERROR.
                 
            FIND FIRST ttInfProt 
                 WHERE ttInfProt.parent-id = RECID(ttProtNFE) NO-ERROR.
            IF AVAIL ttInfProt THEN DO:
                
                ASSIGN tt-nota-fiscal.chave-acesso-nfe = ttInfProt.chNFE.

                CASE ttInfProt.cStat:
                    WHEN 100 THEN ASSIGN tt-nota-fiscal.situacao-nfe = '3'. 
                    WHEN 101 THEN ASSIGN tt-nota-fiscal.situacao-nfe = '6'. 
                    WHEN 102 THEN ASSIGN tt-nota-fiscal.situacao-nfe = '7'. 
                    WHEN 110 THEN ASSIGN tt-nota-fiscal.situacao-nfe = '4'. 
                    OTHERWISE     ASSIGN tt-nota-fiscal.situacao-nfe = '1'. 
                END CASE.
            END.                     
            
            RUN prmapi/prmapi-nota-fiscal.p PERSISTENT SET h-prmapi-nota-fiscal.       
            RUN importarNFFT2015 IN h-prmapi-nota-fiscal(BUFFER tt-nota-fiscal,
                                                         INPUT TABLE item-nota-fiscal,
                                                         INPUT TABLE tt-fat-duplic,
                                                         OUTPUT rw-nota-fiscal,
                                                         OUTPUT TABLE tt-erro).                                      
            
            FOR EACH tt-erro:                                
                ASSIGN c-erros = c-erros + tt-erro.mensagem + " | ".
            END.
            ASSIGN c-erros = RIGHT-TRIM(c-erros," | ").
            
            IF c-erros <> "" THEN
                UNDO,THROW NEW Progress.Lang.AppError(c-erros,0).                
            
            IF NOT CAN-FIND(FIRST nota-fiscal 
                            WHERE ROWID(nota-fiscal) = rw-nota-fiscal) THEN 
                UNDO,THROW NEW Progress.Lang.AppError("API de geraá∆o de notas fiscais n∆o retornou erros, porÇm a nota n∆o foi criada. Consulte o suporte.",0).
                
            RETURN rw-nota-fiscal.                                       
        END.
        
        CATCH erro AS Progress.Lang.Error:            
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1), erro:GetMessageNum(1)).
        END CATCH.
        FINALLY:

            IF VALID-HANDLE(h-prmapi-nota-fiscal) THEN 
                DELETE PROCEDURE h-prmapi-nota-fiscal. 

            RUN prmapi/prmapi-fecha-procedure.p(INPUT "cxbo/bocx180.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "cxbo/bocx185.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "cxbo/bocx362.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi515.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "ftp/ft2089.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin006.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin00881.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin010.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin404re.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "ivbo/boiv029.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi317pr.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi317in.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi321.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi317sd.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi317im1br.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi317va.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi613calc.p").
            RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi538.p").    
        END FINALLY.        
    END METHOD.   

    METHOD PRIVATE ROWID CadastrarClienteDoXML(INPUT data-implant AS DATE ):  
              
        DO TRANSACTION:          
                          
            DEFINE VARIABLE rw-emitente     AS ROWID                    NO-UNDO.
            DEFINE VARIABLE i-cod-emitente  AS INTEGER                  NO-UNDO.    
            DEFINE VARIABLE c-erros         AS CHARACTER                NO-UNDO.
            DEFINE VARIABLE emit            AS CLASS prmapi.Emitente    NO-UNDO.                  
            
            EMPTY TEMP-TABLE tt-emitente.
            EMPTY TEMP-TABLE tt-loc-entr.
            EMPTY TEMP-TABLE tt-achar-erros.
            
            CREATE tt-emitente.            
            emit = NEW prmapi.Emitente().
            emit:CarregarEmitenteComDadosDoXML(INPUT DATASET XMLNotaFiscal,
                                               BUFFER tt-emitente).
            
            FIND FIRST tt-emitente.
            
            FIND FIRST emitente WHERE emitente.cgc = tt-emitente.cgc NO-LOCK NO-ERROR.
            IF NOT AVAILABLE(emitente) THEN DO:            
                RUN cdp/cd9960.p(OUTPUT i-cod-emitente).                                   
                        
                ASSIGN tt-emitente.ind-tipo-movto = 1
                       tt-emitente.cod-emitente   = i-cod-emitente
                       tt-emitente.end-cobranca   = tt-emitente.cod-emitente                                 
                       tt-emitente.nome-abrev     = STRING(tt-emitente.cod-emitente)
                       tt-emitente.nome-matriz    = tt-emitente.nome-abrev
                       tt-emitente.data-implant   = data-implant.
                       
                IF LENGTH(tt-emitente.cgc) = 14 THEN
                    ASSIGN tt-emitente.cod-gr-cli = prm-param-integrador.cod-gr-cli-pj.            
                ELSE
                    ASSIGN tt-emitente.cod-gr-cli = prm-param-integrador.cod-gr-cli-pf.                                                    
                
                FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = tt-emitente.cod-gr-cli NO-LOCK NO-ERROR.
                IF AVAILABLE(gr-cli) THEN
                    ASSIGN tt-emitente.cod-rep       = 2051 //gr-cli.cod-rep // Alteraá‰es Intelbras - Jonatan da Mata - 29/09/23
                           tt-emitente.cod-transp    = gr-cli.cod-transp
                           tt-emitente.cod-cond-pag  = gr-cli.cod-cond-pag
                           tt-emitente.portador      = gr-cli.portador // Alteraá‰es Intelbras - Jonatan da Mata - 29/09/23
                           tt-emitente.modalidade    = gr-cli.modalidade
                           tt-emitente.natureza      = gr-cli.natureza
                           tt-emitente.tp-rec-padrao = gr-cli.tp-rec-desp.                              
                
                IF LENGTH(tt-emitente.cgc) = 14 THEN
                    ASSIGN tt-emitente.natureza   = 2.
                ELSE
                    ASSIGN tt-emitente.natureza   = 1.

                IF tt-emitente.natureza = 1 THEN
                    ASSIGN tt-emitente.ins-estadual = "isento"
                           tt-emitente.contrib-icms = FALSE.
                           
                IF tt-emitente.ins-estadual = '0' OR tt-emitente.ins-estadual = '' OR tt-emitente.ins-estadual = ? THEN
                    ASSIGN tt-emitente.ins-estadual = "isento"
                           tt-emitente.contrib-icms = FALSE.
                
                // Inicio Alteraá‰es Intelbras - Jonatan da Mata - 29/09/2023
                IF TRIM(tt-emitente.telefone[1]) = "" OR tt-emitente.telefone[1] = ? THEN
                DO:
                    ASSIGN tt-emitente.telefone[1] = "99999999999".    
                END.
                IF TRIM(tt-emitente.e-mail) = "" OR tt-emitente.e-mail = ? THEN
                DO:
                    ASSIGN tt-emitente.e-mail = "sem_email@intelbras.com.br".    
                END.
                IF tt-emitente.cod-cond-pag = 0 THEN DO:
                    ASSIGN tt-emitente.cod-cond-pag = 1.    
                END.
                // Fim Alteraá‰es Intelbras - Jonatan da Mata - 29/09/2023
                
                RUN prmapi/prmapi-emitente.p(INPUT TABLE tt-emitente,
                                             INPUT TABLE tt-loc-entr,
                                             OUTPUT TABLE tt-achar-erros,
                                             OUTPUT rw-emitente).
                                             
                FOR EACH tt-achar-erros:
                    ASSIGN c-erros = c-erros + tt-achar-erros.msg + "|".            
                END.
                ASSIGN c-erros = RIGHT-TRIM(c-erros,"|").
                
                IF c-erros <> "" THEN
                    UNDO,THROW NEW Progress.Lang.AppError(c-erros,0).
                
                FIND FIRST emitente WHERE ROWID(emitente) = rw-emitente EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE emitente THEN DO:
                    RELEASE emitente.
                    UNDO,THROW NEW Progress.Lang.AppError("API de emitente n∆o retornou erros, porÇm o emitente n∆o foi criado. Consulte o suporte.",0).    
                END.
                ELSE DO:
                    // Inicio Alteraá‰es Intelbras - Jonatan da Mata - 29/09/2023
                    IF TRIM(emitente.telefone[1]) = "" OR tt-emitente.telefone[1] = ? THEN
                    DO:
                        ASSIGN emitente.telefone[1] = "99999999999".    
                    END.

                    IF emitente.cod-cond-pag = 0 THEN DO:
                        ASSIGN emitente.cod-cond-pag = 1.    
                    END.
          
                    FIND FIRST int-emitente EXCLUSIVE-LOCK
                         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
                    IF NOT AVAIL int-emitente THEN
                    DO:
                        CREATE int-emitente.
                        ASSIGN int-emitente.cod-emitente = emitente.cod-emitente.
                               int-emitente.cod-gr-cob   = 9.
                    END.
                    ELSE DO:
                        ASSIGN int-emitente.cod-gr-cob   = 9.
                    END.
                    RELEASE int-emitente. 
                    
                    // Fim Alteraá‰es Intelbras - Jonatan da Mata - 29/09/2023
                END.
                
                EnviarEmailDoClienteCadastrado(BUFFER emitente). 
                RELEASE emitente.
                RETURN rw-emitente.
            END.
            ELSE 
                RETURN ROWID(emitente).
    
            CATCH erro AS Progress.Lang.Error:                                          
                UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
            END CATCH.
        END.
    END METHOD.    

    METHOD PRIVATE VOID EnviarEmailDoClienteCadastrado(BUFFER b-emitente FOR emitente):
        
        DEFINE VARIABLE c-email-destino AS CHARACTER NO-UNDO.        
        
        FOR EACH usuar_grp_usuar WHERE usuar_grp_usuar.cod_grp_usuar = prm-param-integrador.cod-grp-usuar-cliente NO-LOCK,
            FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = usuar_grp_usuar.cod_usuario NO-LOCK:
            
            IF usuar_mestre.cod_e_mail_local <> "" THEN     
                ASSIGN c-email-destino = c-email-destino + usuar_mestre.cod_e_mail_local + ";".                   
        END. 
        ASSIGN c-email-destino = RIGHT-TRIM(c-email-destino,";").
        
        IF c-email-destino <> "" THEN 
            RUN prmapi/prmapi-mail.p(INPUT c-email-destino,
                                     INPUT "Novo cliente " + STRING(b-emitente.cod-emitente) + " cadastrado - Projeto Integraá∆o " + prm-projeto-integrador.cod-proj-int,
                                     INPUT "C¢digo: " + STRING(b-emitente.cod-emitente) + chr(10) +
                                           "Nome: " + b-emitente.nome-emit,
                                     INPUT "").                                                                         
    END METHOD.
    
    METHOD PRIVATE VOID EnviarEmailNFComErro(INPUT p-msg-erro AS CHARACTER):
        
        DEFINE VARIABLE c-email-destino AS CHARACTER NO-UNDO.        
        
        FOR EACH usuar_grp_usuar WHERE usuar_grp_usuar.cod_grp_usuar = prm-param-integrador.cod-grp-usuar-integracao NO-LOCK,
            FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = usuar_grp_usuar.cod_usuario NO-LOCK:
            
            IF usuar_mestre.cod_e_mail_local <> "" THEN     
                ASSIGN c-email-destino = c-email-destino + usuar_mestre.cod_e_mail_local + ";".                   
        END. 
        ASSIGN c-email-destino = RIGHT-TRIM(c-email-destino,";").
        
        IF c-email-destino <> "" THEN 
            RUN prmapi/prmapi-mail.p(INPUT c-email-destino,
                                     INPUT "Erro geraá∆o de nota fiscal - Projeto Integraá∆o " + prm-projeto-integrador.cod-proj-int,
                                     INPUT "Erro na geraá∆o da nota fiscal do Projeto Integraá∆o " + prm-projeto-integrador.cod-proj-int + CHR(10) +
                                           "Arquivo: " + c-arquivo-xml + chr(10) +
                                           "Mensagem: " + p-msg-erro,
                                     INPUT "").                                                                         
    END METHOD.   

    METHOD PRIVATE VOID CriarLogNF(INPUT p-nota-fiscal AS ROWID,
                                   INPUT p-erros AS CHARACTER,
                                   INPUT p-tipo AS INTEGER):
        
        DEFINE VARIABLE c-chave-acesso AS CHARACTER NO-UNDO.
        
        FOR FIRST ttInfProt:
            ASSIGN c-chave-acesso = ttInfProt.chNFe.
        END.
        
        FIND FIRST prm-nf-integrador WHERE prm-nf-integrador.arquivo-xml = c-arquivo-xml EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE(prm-nf-integrador) THEN DO:
            CREATE prm-nf-integrador. 
            ASSIGN prm-nf-integrador.arquivo-xml = c-arquivo-xml.                           
        END.                                                      
       
        ASSIGN prm-nf-integrador.cod-proj-int     = prm-projeto-integrador.cod-proj-int
               prm-nf-integrador.tipo             = p-tipo
               prm-nf-integrador.chave-acesso-nfe = c-chave-acesso
               prm-nf-integrador.data-integracao  = TODAY.         

        IF p-erros <> "" THEN DO:
            ASSIGN prm-nf-integrador.situacao     = 2
                   prm-nf-integrador.msg-erro     = SUBSTRING(p-erros,1,9000)
                   prm-nf-integrador.cod-estabel  = ""
                   prm-nf-integrador.nr-nota-fis  = ""
                   prm-nf-integrador.serie        = ""
                   prm-nf-integrador.cod-emitente = ?
                   prm-nf-integrador.nat-operacao = "".
        END.

        FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = p-nota-fiscal NO-LOCK NO-ERROR.
        IF AVAILABLE(nota-fiscal) THEN DO:
            ASSIGN prm-nf-integrador.cod-estabel  = nota-fiscal.cod-estabel
                   prm-nf-integrador.nr-nota-fis  = nota-fiscal.nr-nota-fis
                   prm-nf-integrador.serie        = nota-fiscal.serie
                   prm-nf-integrador.cod-emitente = nota-fiscal.cod-emitente
                   prm-nf-integrador.nat-operacao = nota-fiscal.nat-operacao
                   prm-nf-integrador.situacao     = 1
                   prm-nf-integrador.msg-erro     = "".   
        END.    
    END METHOD.    

    METHOD PRIVATE VOID MoverXMLImportado(INPUT p-tipo AS INTEGER):
        
        /*TIPO    1 - VENDA    */
        /*        2 - CANCELADA*/
        /*        3 - REMESSA  */
        /*        4 - RETORNO  */
        /*        5 - DEVOLUÄ«O*/
        /*        6 - CT-E     */
        
        CASE p-tipo:
            WHEN 1 THEN
                FILE-INFO:FILE-NAME = RIGHT-TRIM(prm-projeto-integrador.dir-nfe-venda, "/") + "/Importados".
            WHEN 3 THEN
                FILE-INFO:FILE-NAME = RIGHT-TRIM(prm-projeto-integrador.dir-nfe-rem, "/") + "/Importados".
            OTHERWISE
                UNDO,THROW NEW Progress.Lang.AppError("Tipo da nota fiscal deve ser de VENDA (1) ou REMESSA (3). (" + STRING(p-tipo) + ") informado", 0).
        END CASE.
        
        IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
            OS-CREATE-DIR VALUE(FILE-INFO:FILE-NAME).
/*             IF OS-ERROR <> 0 THEN                                                                                                            */
/*                 UNDO,THROW NEW Progress.Lang.AppError("N∆o foi poss°vel criar a pasta 'Importados'. C¢digo do erro " + STRING(OS-ERROR), 0). */
        END.        

        OS-RENAME VALUE(c-arquivo-xml) VALUE(FILE-INFO:FILE-NAME).
/*         IF OS-ERROR <> 0 THEN                                                                                                                              */
/*             UNDO,THROW NEW Progress.Lang.AppError("N∆o foi poss°vel mover arquivo XML para a pasta de importados. C¢digo do erro " + STRING(OS-ERROR), 0). */
/*                                                                                                                                                            */
/*         CATCH erro AS Progress.Lang.Error:                                                                                                                 */
/*             UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).                                                               */
/*         END CATCH.                                                                                                                                         */
    END METHOD.   

    METHOD PRIVATE ROWID GetNFDoXML():
        
        FOR FIRST ttInfProt:

            /* Removido em 06/10/2023 por Rafael Rosa devido a performance */
/*             FIND FIRST nota-fiscal NO-LOCK                                                   */
/*                  WHERE nota-fiscal.cod-chave-aces-nf-eletro BEGINS ttInfProt.chNFe NO-ERROR. */
/*             IF AVAIL nota-fiscal THEN                                                        */
/*                 RETURN ROWID(nota-fiscal).                                                   */
            /* Fim da RemoÁ„o por Rafael Rosa em 06/10/2023 */    
            
            FIND FIRST prm-nf-integrador NO-LOCK
                 WHERE prm-nf-integrador.chave-acesso-nfe = ttInfProt.chNFe NO-ERROR.            
            IF AVAILABLE(prm-nf-integrador) THEN DO:
                
                FIND FIRST nota-fiscal NO-LOCK
                     WHERE nota-fiscal.cod-estabel = prm-nf-integrador.cod-estabel
                       AND nota-fiscal.serie       = prm-nf-integrador.serie
                       AND nota-fiscal.nr-nota-fis = prm-nf-integrador.nr-nota-fis NO-ERROR.
                IF AVAILABLE(nota-fiscal) THEN
                    RETURN ROWID(nota-fiscal).                                                                                                
            END.                     
        END.

        RETURN ?.
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).               
        END CATCH.

    END METHOD. 

/*    METHOD PRIVATE LOGICAL IsItemIPIOutros(BUFFER b-item-notafiscal FOR item-nota-fiscal):                        */
/*        IF (b-item-notafiscal.it-codigo         = "2689" OR b-item-notafiscal.it-codigo         = "1023") AND     */
/*           (b-item-notafiscal.nat-operacao BEGINS "5105" OR b-item-notafiscal.nat-operacao BEGINS "6105") THEN DO:*/
/*            RETURN TRUE.                                                                                          */
/*        END.                                                                                                      */
/*        ELSE IF (b-item-notafiscal.nat-operacao BEGINS "5949"  OR                                                 */
/*                 b-item-notafiscal.nat-operacao BEGINS "6949") THEN                                               */
/*            RETURN TRUE.                                                                                          */
/*                                                                                                                  */
/*        RETURN FALSE.                                                                                             */
/*    END METHOD.                                                                                                   */

    DESTRUCTOR PUBLIC NotaVendaIntegrador ( ):
    END DESTRUCTOR.
END CLASS.
