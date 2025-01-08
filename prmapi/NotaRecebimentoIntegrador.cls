USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS prmapi.NotaRecebimentoIntegrador:
     
    {inbo/boin090.i tt-docum-est}
    {inbo/boin176.i tt-item-doc-est}
    {inbo/boin092.i tt-dupli-apagar}
    {inbo/boin367.i tt-rat-lote}
    {prmapi/XMLNotaFiscal.i}
    {prmapi/prmapi-emitente.i}
    {prmapi/prmapi-docum-est-integrador.i}
    
    DEFINE VARIABLE c-arquivo-xml AS CHARACTER NO-UNDO.

    CONSTRUCTOR PUBLIC NotaRecebimentoIntegrador(INPUT c-cod-proj-int AS CHARACTER):
        
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

    METHOD PUBLIC ROWID GerarNFPeloArquivoXML(INPUT p-arquivo AS CHARACTER, INPUT v_cod_usuar_corren AS CHARACTER, INPUT p-tipo AS INTEGER): 

        DEFINE VARIABLE rw-docum-est    AS ROWID        NO-UNDO.
        DEFINE VARIABLE c-erros         AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE l-ok            AS LOGICAL      NO-UNDO.
        
        ASSIGN c-arquivo-xml = p-arquivo.
                        
        FILE-INFO:FILE-NAME = c-arquivo-xml.
        IF FILE-INFO:FULL-PATHNAME = ? THEN
            UNDO, THROW NEW Progress.Lang.AppError("Arquivo " + c-arquivo-xml + " n∆o encontrado", 0).
            
        ASSIGN l-ok = DATASET XMLNotaFiscal:READ-XML("file", c-arquivo-xml, "empty", ?, ?) NO-ERROR.
        IF NOT l-ok THEN
            UNDO, THROW NEW Progress.Lang.AppError("XML da nota n∆o corresponde a um recebimento v†lido", 0).
        
        ASSIGN rw-docum-est = GetNFDoXML().
        
        IF rw-docum-est <> ? THEN DO:
            
            FIND FIRST docum-est NO-LOCK
                 WHERE ROWID(docum-est) = rw-docum-est NO-ERROR.
            IF AVAILABLE(docum-est) THEN DO:
                MoverXMLImportado(INPUT p-tipo).
                UNDO,THROW NEW Progress.Lang.AppError("Nota Fiscal " + docum-est.nro-docto + ", SÇrie " + docum-est.serie-docto + ", Emitente " + STRING(docum-est.cod-emitente) + ", Nat Oper " + docum-est.nat-operacao + " j† gerada para o XML. Somente o arquivo XML ser† movido.",0).                
            END.
        END.
            
        ASSIGN rw-docum-est = ?
               rw-docum-est = GerarNotaFiscal(INPUT v_cod_usuar_corren,
                                              INPUT p-tipo).
        FIND FIRST docum-est EXCLUSIVE-LOCK
             WHERE ROWID(docum-est) = rw-docum-est NO-ERROR.
        IF AVAILABLE(docum-est) THEN DO:
        
            // Inicio Alteraá‰es Intelbras - Jonatan da Mata - 29/09/2023
            ASSIGN OVERLAY(docum-est.char-2,143,8) = "9".
            
            FIND FIRST int-docum-est EXCLUSIVE-LOCK
                 WHERE int-docum-est.serie-docto  = docum-est.serie-docto
                   AND int-docum-est.nro-docto    = docum-est.nro-docto  
                   AND int-docum-est.cod-emitente = docum-est.cod-emitente
                   AND int-docum-est.nat-operacao = docum-est.nat-operacao NO-ERROR.
            IF NOT AVAIL int-docum-est THEN DO:
                CREATE int-docum-est.
                ASSIGN int-docum-est.serie-docto  = docum-est.serie-docto
                       int-docum-est.nro-docto    = docum-est.nro-docto  
                       int-docum-est.cod-emitente = docum-est.cod-emitente
                       int-docum-est.nat-operacao = docum-est.nat-operacao.
            END.
            ASSIGN int-docum-est.cod-msg-devolucao = 508
                   int-docum-est.nota-completa     = YES.
            // Fim Alteraá‰es Intelbras - Jonatan da Mata - 29/09/2023

            RELEASE int-docum-est.

            MoverXMLImportado(INPUT p-tipo).
        END.
        RELEASE docum-est.

        RETURN rw-docum-est.

        CATCH erro AS Progress.Lang.Error :
            ASSIGN c-erros = erro:GetMessage(1).                                    
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).                  
        END CATCH.
        FINALLY:
            CriarLogNF(INPUT rw-docum-est,
                       INPUT c-erros,
                       INPUT p-tipo).                                                              
                       
            IF c-erros <> "" THEN DO:
                EnviarEmailNFComErro(INPUT c-erros).
            END.
        END FINALLY.
    END METHOD.

    METHOD PRIVATE ROWID GerarNotaFiscal(INPUT v_cod_usuar_corren AS CHARACTER, INPUT p-tipo AS INTEGER):

        DEFINE VARIABLE rw-docum-est            AS ROWID        NO-UNDO.
        DEFINE VARIABLE rw-emitente             AS ROWID        NO-UNDO.
        DEFINE VARIABLE c-dhEmi                 AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE dt-emissao              AS DATE         NO-UNDO.
        DEFINE VARIABLE i-seq-item              AS INTEGER      NO-UNDO.
        DEFINE VARIABLE i-seq-adc               AS INTEGER      NO-UNDO.
        DEFINE VARIABLE c-natur-oper            AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-nro-docto             AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-dVal                  AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-dFab                  AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE dt-vali-lote            AS DATE         NO-UNDO.
        DEFINE VARIABLE dat-fabricc-lote        AS DATE         NO-UNDO.
        DEFINE VARIABLE h-docum-est-integrador  AS HANDLE       NO-UNDO.
        DEFINE VARIABLE c-erros                 AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE l-ok                    AS LOGICAL      NO-UNDO.
        DEFINE VARIABLE c-nat-oper              AS CHAR         NO-UNDO.
        DEFINE VARIABLE l-return                AS LOG          NO-UNDO.
        DEFINE VARIABLE h-boes505               AS HANDLE       NO-UNDO.
        DEFINE VARIABLE c-compr-fabric          AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE i-seq-ttNFref           AS INT          NO-UNDO.

        EMPTY TEMP-TABLE tt-docum-est.
        EMPTY TEMP-TABLE tt-item-doc-est.
        EMPTY TEMP-TABLE tt-dupli-apagar.
        EMPTY TEMP-TABLE tt-rat-lote.

        DO TRANSACTION ON ERROR UNDO, LEAVE:
            
            ASSIGN rw-docum-est = GetNFDoXML().
            IF rw-docum-est <> ? THEN DO:
                
                FIND FIRST docum-est NO-LOCK
                     WHERE ROWID(docum-est) = rw-docum-est NO-ERROR.
                IF AVAIL docum-est THEN
                    UNDO, THROW NEW Progress.Lang.AppError("Nota Fiscal " + docum-est.nro-docto + ", SÇrie " + docum-est.serie-docto + ", Emitente " + STRING(docum-est.cod-emitente) + ", Nat Oper " + docum-est.nat-operacao + " j† gerada para o XML", 0).
            END.
            
            FOR FIRST ttInfNFe:
                
                ASSIGN rw-emitente = BuscarEmitenteDoXML().
                FIND FIRST emitente WHERE ROWID(emitente) = rw-emitente NO-LOCK NO-ERROR.
    
                FOR FIRST ttEmit:
                    FIND FIRST estabelec WHERE estabelec.cgc = ttEmit.CNPJ NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE(estabelec) THEN
                        UNDO, THROW NEW Progress.Lang.AppError(INPUT "Estabelecimento n∆o localizado com CNPJ " + ttEmit.CNPJ, 0).
                END.
                
                CREATE tt-docum-est.                          
                ASSIGN tt-docum-est.cod-estabel  = estabelec.cod-estabel
                       tt-docum-est.estab-fisc   = estabelec.cod-estabel
                       tt-docum-est.cod-emitente = emitente.cod-emitente
                       tt-docum-est.cod-entrega  = emitente.cod-entrega
                       tt-docum-est.usuario      = v_cod_usuar_corren
                       tt-docum-est.origem       = IF p-tipo = 4 /*Retorno*/ THEN "I" ELSE /*Devoluá∆o*/ "D"
                       tt-docum-est.pais-origem  = "RE1001"
                       OVERLAY(tt-docum-est.char-2,143,8) = '9'. //Rafael Rosa em 06/10
                
                IF p-tipo = 4 /*4 - RETORNO*/ THEN
                    ASSIGN tt-docum-est.ct-transit = prm-projeto-integrador.ct-codigo.
                
                FOR FIRST ttIde:
    
                    ASSIGN c-dhEmi    = SUBSTRING(ttIde.dhEmi,1,10)
                           dt-emissao = DATE(INTEGER(ENTRY(2,c-dhEmi,"-")),
                                             INTEGER(ENTRY(3,c-dhEmi,"-")),
                                             INTEGER(ENTRY(1,c-dhEmi,"-"))) NO-ERROR.
    
                    ASSIGN tt-docum-est.nro-docto   = ttIde.nNF
                           tt-docum-est.serie-docto = prm-projeto-integrador.serie //ttIde.serie
                           tt-docum-est.dt-emissao  = dt-emissao
                           tt-docum-est.dt-trans    = dt-emissao.
                END.
                       
                FOR FIRST ttTransporta:
                    FIND FIRST transporte WHERE transporte.cgc = ttTransporta.cnpj NO-LOCK NO-ERROR.
                    IF AVAILABLE(transporte) THEN
                        ASSIGN tt-docum-est.nome-transp = transporte.nome-abrev.    
                END.       
                
                FOR FIRST ttInfAdic:
                    ASSIGN tt-docum-est.observacao = ttInfAdic.infCpl.
                END.
                
                FOR FIRST ttVol:
                    ASSIGN tt-docum-est.peso-liquido-tot = ttVol.pesoB
                           tt-docum-est.peso-bruto-tot   = ttVol.pesoL.
                END.
                       
                FOR FIRST ttICMSTot:                
                    ASSIGN tt-docum-est.valor-mercad  = ttICMSTot.vProd
                           tt-docum-est.valor-frete   = ttICMSTot.vFrete
                           tt-docum-est.valor-outras  = ttICMSTot.vOutro
                           tt-docum-est.valor-seguro  = ttICMSTot.vSeg.
                END.
                                                              
                FIND FIRST ttProtNFE 
                     WHERE ttProtNFE.parent-id = RECID(ttNfe) NO-ERROR.
    
                FIND FIRST ttInfProt 
                     WHERE ttInfProt.parent-id = RECID(ttProtNFE) NO-ERROR.
                IF AVAIL ttInfProt THEN DO:
                    tt-docum-est.cod-chave-aces-nf-eletro = ttInfProt.chNFE.
                END.
                
                /*--- Inicia a vari†vel da sequància dos itens ---*/
                ASSIGN i-seq-item = 5.
                
                FOR EACH ttDet
                   WHERE ttDet.parent-id = RECID(ttInfNFe):
    
                    FOR EACH ttProd
                       WHERE ttProd.parent-id = RECID(ttDet):
                        
                        /*--- Valida CFOP entrada - Notas de retorno e devoluá∆o dever∆o ter CFOP < 5 ---*/
                        IF INTEGER(SUBSTRING(ttProd.CFOP, 1, 1)) >= 5 THEN
                            UNDO,THROW NEW Progress.Lang.AppError(INPUT SUBSTITUTE("CFOP &1 da nota fiscal n∆o corresponde a uma nota de entrada", ttProd.CFOP), 0).
                        /*-------------------------------------------------------------------------------*/
                        
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
                            /* IF NOT AVAIL prm-regras-integrador THEN
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
                                       //AND   prm-regras-integrador.ind-contribuinte   = "*"
                                       AND   prm-regras-integrador.it-codigo        = "*" NO-ERROR.

                            /*
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

                            IF NOT AVAIL prm-regras-integrador THEN
                                UNDO,THROW NEW Progress.Lang.AppError(INPUT SUBSTITUTE("Nenhuma regra de natureza de operaá∆o foi parametrizada para a chave CFOP &1, Estado &2, Contribuinte &3, Item &4, Origem do Item &5. Verificar o programa PRM4103",
                                                                                       ttProd.CFOP,
                                                                                       emitente.estado,
                                                                                       STRING(emitente.contrib-icms,"Sim/Nao"),
                                                                                       ITEM.it-codigo,
                                                                                       c-compr-fabric), 0).
    
                            //ASSIGN c-natur-oper = IF p-tipo = 4 THEN prm-regras-integrador.nat-oper-ret ELSE IF p-tipo = 5 THEN prm-regras-integrador.nat-oper-dev ELSE "".
                            ASSIGN c-natur-oper = prm-regras-integrador.nat-operacao.
                        
                        END.
                        
                        FIND FIRST natur-oper NO-LOCK
                             WHERE natur-oper.nat-operacao = c-natur-oper NO-ERROR.
                        IF NOT AVAILABLE(natur-oper) THEN
                            UNDO,THROW NEW Progress.Lang.AppError(INPUT "Natureza de Operaá∆o " + c-natur-oper + " n∆o cadastrada no sistema.", 0).
                        
                        IF NOT CAN-FIND(FIRST tt-item-doc-est NO-LOCK) THEN DO:
                            
/*                            ASSIGN c-nro-docto = "1".                                                           */
/*                                                                                                                */
/*                            /*-- Rotina para buscar £ltimo n£mero do documento --*/                             */
/*                            FOR EACH docum-est NO-LOCK                                                          */
/*                               WHERE docum-est.serie-docto  = tt-docum-est.serie-docto                          */
/*                                 AND docum-est.cod-emitente = tt-docum-est.cod-emitente                         */
/*                                 AND docum-est.nat-operacao = c-natur-oper                                      */
/*                            BREAK BY INTEGER(docum-est.nro-docto) DESC:                                         */
/*                                                                                                                */
/*                                ASSIGN c-nro-docto = STRING(INT(docum-est.nro-docto) + 1).                      */
/*                                LEAVE.                                                                          */
/*                            END.                                                                                */
/*                                                                                                                */
/*                            ASSIGN c-nro-docto               = FILL("0",(7 - LENGTH(c-nro-docto))) + c-nro-docto*/
/*                                   tt-docum-est.nro-docto    = c-nro-docto                                      */
/*                                   tt-docum-est.nat-operacao = c-natur-oper.                                    */
                                   
                            ASSIGN tt-docum-est.nat-operacao = c-natur-oper.
                            /*-- --*/
                        END.
    
                        ASSIGN i-seq-item = i-seq-item + 5.
                        
                        CREATE tt-item-doc-est.
                        ASSIGN tt-item-doc-est.cod-emitente      = tt-docum-est.cod-emitente
                               tt-item-doc-est.nro-docto         = tt-docum-est.nro-docto
                               tt-item-doc-est.serie-docto       = tt-docum-est.serie-docto
                               tt-item-doc-est.nat-operacao      = tt-docum-est.nat-operacao
                               tt-item-doc-est.nat-of            = c-natur-oper
                               tt-item-doc-est.it-codigo         = item.it-codigo
                               tt-item-doc-est.sequencia         = i-seq-item
                               tt-item-doc-est.quantidade        = ttProd.qCom
                               tt-item-doc-est.peso-liquido-item = item.peso-liquido
                               tt-item-doc-est.peso-bruto-item   = item.peso-bruto
                               tt-item-doc-est.preco-unit        = ttProd.vUnCom
                               tt-item-doc-est.preco-total       = ttProd.vUnCom * ttProd.qCom
                               tt-item-doc-est.cod-depos         = prm-projeto-integrador.cod-depos
                               tt-item-doc-est.cod-localiz       = ""
                               tt-item-doc-est.baixa-ce          = IF p-tipo = 4 /*Retorno*/ THEN FALSE ELSE /*Devoluá∆o*/ TRUE
                               tt-item-doc-est.desconto[1]       = ttProd.vDesc
                               tt-item-doc-est.ipi-outras        = ttProd.vUnCom * ttProd.qCom
                               tt-item-doc-est.base-ipi          = ttProd.vUnCom * ttProd.qCom.

                        FOR FIRST ttIde:
                            IF ttIde.natOp = "Outras Entradas - Retorno de Deposito Temporario" THEN
                                ASSIGN tt-item-doc-est.cod-depos = prm-projeto-integrador.cod-depos-saida.
                        END.

                        FOR FIRST ttObsCont:
                            IF ttObsCont.xTexto BEGINS "DEVOLUTION_PLACES" THEN DO:
                                ASSIGN tt-item-doc-est.cod-depos   = "FUL"
                                       tt-item-doc-est.cod-localiz = "Transito".
                            END.
                        END.
                        
                        IF p-tipo >= 4 /* Retorno */ AND p-tipo <= 5 /*Devoluá∆o*/ THEN DO:

                            ASSIGN i-seq-ttNFref = 5.

                            FOR EACH ttNFref NO-LOCK:

                                ASSIGN i-seq-ttNFref = i-seq-ttNFref + 5.

                                IF i-seq-item = i-seq-ttNFref THEN DO:
                                    FIND FIRST estabelec NO-LOCK
                                         WHERE estabelec.cgc = SUBSTR(ttNFref.refNFe,7,14) NO-ERROR.
                                    IF AVAIL estabelec THEN DO:
    
                                        FIND FIRST nota-fiscal NO-LOCK
                                             WHERE nota-fiscal.cod-estabel  = estabelec.cod-estabel
                                               AND nota-fiscal.serie        = STRING(INT(SUBSTR(ttNFref.refNFe,23,3)))
                                               AND nota-fiscal.nr-nota-fis  = STRING(INT(SUBSTR(ttNFref.refNFe,28,7)),'9999999') NO-ERROR.
    
                                        IF AVAIL nota-fiscal THEN DO:
    
                                            FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK
                                                 WHERE it-nota-fisc.it-codigo = tt-item-doc-est.it-codigo NO-ERROR.
                                            IF AVAIL it-nota-fisc THEN
                                                ASSIGN tt-item-doc-est.nro-docto-terc = nota-fiscal.nr-nota-fis
                                                       tt-item-doc-est.serie-terc     = nota-fiscal.serie
                                                       tt-item-doc-est.seq-terc       = it-nota-fisc.nr-seq-fat
                                                       tt-item-doc-est.nat-terc       = nota-fiscal.nat-operacao.
                                            ELSE
                                                UNDO, THROW NEW Progress.Lang.AppError(SUBSTITUTE("Item &1 n∆o encontrado na nota fiscal de venda referenciada", tt-item-doc-est.it-codigo), 0).
                                        END.
                                        ELSE
                                            UNDO, THROW NEW Progress.Lang.AppError("N∆o encontrada NF-e referenciada no sistema Chave: " + ttNFref.refNFe, 0).
                                    END.
                                    ELSE
                                        UNDO, THROW NEW Progress.Lang.AppError("N∆o encontrada Estabelecimento referenciada na Chave: " + ttNFref.refNFe, 0).
                                END.
                            END.
                        END.

                        IF p-tipo = 5 /*Devoluá∆o*/ THEN DO:
                            FOR FIRST ttPISOutr:
                                ASSIGN tt-item-doc-est.base-pis          = ttPISOutr.vBC
                                       tt-item-doc-est.valor-pis         = ttPISOutr.vPIS.
                            END.
    
                            FOR FIRST ttCOFINSOutr:
                                ASSIGN tt-item-doc-est.val-base-calc-cofins = ttCOFINSOutr.vBC
                                       tt-item-doc-est.val-cofins           = ttCOFINSOutr.vCOFINS.
                            END.  

                            FOR FIRST ttICMS10:
                                ASSIGN tt-item-doc-est.base-subs[1] = ttICMS10.vBCST  
                                       tt-item-doc-est.vl-subs[1]   = ttICMS10.vICMSST. 
                            END.
                        END.

                        FIND FIRST ttImposto 
                             WHERE ttImposto.parent-id = RECID(ttDet) NO-ERROR.
                        FIND FIRST ttICMS 
                             WHERE ttICMS.parent-id = RECID(ttImposto) NO-ERROR.
                        FOR FIRST ttICMS00 
                            WHERE ttICMS00.parent-id = RECID(ttICMS):
                            ASSIGN tt-item-doc-est.aliquota-icm = ttICMS00.pICMS
                                   tt-item-doc-est.base-icm     = ttICMS00.vBC
                                   tt-item-doc-est.valor-icm    = ttICMS00.vICMS.
                        END.
                        FOR FIRST ttICMS10 
                            WHERE ttICMS10.parent-id = RECID(ttICMS):
                            ASSIGN tt-item-doc-est.aliquota-icm = ttICMS10.pICMS
                                   tt-item-doc-est.base-icm     = ttICMS10.vBC
                                   tt-item-doc-est.valor-icm    = ttICMS10.vICMS.
                        END.
                        FOR FIRST ttICMS20 
                            WHERE ttICMS20.parent-id = RECID(ttICMS):
                            ASSIGN tt-item-doc-est.aliquota-icm = ttICMS20.pICMS
                                   tt-item-doc-est.base-icm     = ttICMS20.vBC
                                   tt-item-doc-est.valor-icm    = ttICMS20.vICMS.
                        END.
                        FOR FIRST ttICMS51 
                            WHERE ttICMS51.parent-id = RECID(ttICMS):
                            ASSIGN tt-item-doc-est.aliquota-icm = ttICMS51.pICMS
                                   tt-item-doc-est.base-icm     = ttICMS51.vBC
                                   tt-item-doc-est.valor-icm    = ttICMS51.vICMS.
                        END.
                        FOR FIRST ttICMS70 
                            WHERE ttICMS70.parent-id = RECID(ttICMS):
                            ASSIGN tt-item-doc-est.aliquota-icm = ttICMS70.pICMS
                                   tt-item-doc-est.base-icm     = ttICMS70.vBC
                                   tt-item-doc-est.valor-icm    = ttICMS70.vICMS.
                        END.
                        FOR FIRST ttICMS90 
                            WHERE ttICMS90.parent-id = RECID(ttICMS):
                            ASSIGN tt-item-doc-est.aliquota-icm = ttICMS90.pICMS
                                   tt-item-doc-est.base-icm     = ttICMS90.vBC
                                   tt-item-doc-est.valor-icm    = ttICMS90.vICMS.
                        END.
                        
                        IF p-tipo = 4 /*4 - RETORNO*/ THEN
                            ASSIGN tt-item-doc-est.ct-codigo = prm-projeto-integrador.ct-codigo.
                            
                        FOR EACH ttRastro 
                           WHERE ttRastro.parent-id = RECID(ttProd):
                        
                            ASSIGN c-dVal           = SUBSTRING(ttRastro.dVal,1,10) 
                                   c-dFab           = SUBSTRING(ttRastro.dFab,1,10)                                              
                                   dt-vali-lote     = DATE(INTEGER(ENTRY(2,c-dVal,"-")),
                                                           INTEGER(ENTRY(3,c-dVal,"-")),
                                                           INTEGER(ENTRY(1,c-dVal,"-"))) 
                                   dat-fabricc-lote = DATE(INTEGER(ENTRY(2,c-dFab,"-")),
                                                           INTEGER(ENTRY(3,c-dFab,"-")),
                                                           INTEGER(ENTRY(1,c-dFab,"-"))) NO-ERROR.
    
                            CREATE tt-rat-lote.
                            ASSIGN tt-rat-lote.cod-emitente     = tt-docum-est.cod-emitente
                                   tt-rat-lote.serie-docto      = tt-docum-est.serie-docto
                                   tt-rat-lote.nro-docto        = tt-docum-est.nro-docto
                                   tt-rat-lote.nat-operacao     = tt-docum-est.nat-operacao
                                   tt-rat-lote.tipo-nota        = tt-docum-est.tipo-nota
                                   tt-rat-lote.sequencia        = tt-item-doc-est.sequencia
                                   tt-rat-lote.it-codigo        = tt-item-doc-est.it-codigo
                                   tt-rat-lote.cod-depos        = prm-projeto-integrador.cod-depos
                                   tt-rat-lote.cod-localiz      = ""
                                   tt-rat-lote.quantidade       = ttRastro.qLote
                                   tt-rat-lote.lote             = ttRastro.nLote
                                   tt-rat-lote.dt-vali-lote     = dt-vali-lote
                                   tt-rat-lote.dat-fabricc-lote = dat-fabricc-lote.

                            FOR FIRST ttIde:
                                IF ttIde.natOp = "Outras Entradas - Retorno de Deposito Temporario" THEN
                                    ASSIGN tt-rat-lote.cod-depos = prm-projeto-integrador.cod-depos-saida.
                            END.

                            FOR FIRST ttObsCont:
                                IF ttObsCont.xTexto BEGINS "DEVOLUTION_PLACES" THEN DO:
                                    ASSIGN tt-rat-lote.cod-depos   = "FUL"
                                           tt-rat-lote.cod-localiz = "Transito".
                                END.
                            END.
                        END.
                        
                        IF NOT CAN-FIND(FIRST ttRastro 
                                        WHERE ttRastro.parent-id = RECID(ttProd)) 
                        THEN DO:
                            
                            CREATE tt-rat-lote.
                            ASSIGN tt-rat-lote.cod-emitente     = tt-docum-est.cod-emitente
                                   tt-rat-lote.serie-docto      = tt-docum-est.serie-docto
                                   tt-rat-lote.nro-docto        = tt-docum-est.nro-docto
                                   tt-rat-lote.nat-operacao     = tt-docum-est.nat-operacao
                                   tt-rat-lote.tipo-nota        = tt-docum-est.tipo-nota
                                   tt-rat-lote.sequencia        = tt-item-doc-est.sequencia
                                   tt-rat-lote.it-codigo        = tt-item-doc-est.it-codigo
                                   tt-rat-lote.cod-depos        = prm-projeto-integrador.cod-depos
                                   tt-rat-lote.cod-localiz      = ""
                                   tt-rat-lote.quantidade       = tt-item-doc-est.quantidade.

                            FOR FIRST ttIde:
                                IF ttIde.natOp = "Outras Entradas - Retorno de Deposito Temporario" THEN
                                    ASSIGN tt-rat-lote.cod-depos = prm-projeto-integrador.cod-depos-saida.
                            END.

                            FOR FIRST ttObsCont:
                                IF ttObsCont.xTexto BEGINS "DEVOLUTION_PLACES" THEN DO:
                                    ASSIGN tt-rat-lote.cod-depos   = "FUL"
                                           tt-rat-lote.cod-localiz = "Transito".
                                END.
                            END.

                        END.
                    END.
                END.
                
                EMPTY TEMP-TABLE tt-erro-docum.
                
                RUN prmapi/prmapi-docum-est-integrador.p PERSISTENT SET h-docum-est-integrador(INPUT-OUTPUT TABLE tt-docum-est,
                                                                                               INPUT-OUTPUT TABLE tt-item-doc-est,
                                                                                               INPUT-OUTPUT TABLE tt-dupli-apagar,
                                                                                               INPUT-OUTPUT TABLE tt-rat-lote,
                                                                                               OUTPUT TABLE tt-erro-docum).
                                                                                               
                ASSIGN c-erros = "".
                
                FOR EACH tt-erro-docum NO-LOCK:
                    
                    FIND FIRST cadast_msg NO-LOCK USE-INDEX cdstmsg_id
                         WHERE cadast_msg.cdn_msg = tt-erro-docum.cd-erro NO-ERROR.
                    IF AVAIL cadast_msg AND cadast_msg.idi_tip_msg = 1 THEN DO:
                        ASSIGN c-erros = c-erros + STRING(tt-erro-docum.cd-erro) + " - " + tt-erro-docum.mensagem + " | "
                               c-erros = RIGHT-TRIM(c-erros, " | ").
                    END.
                END.
                    
                IF TRIM(c-erros) <> "" THEN DO:
                    UNDO, THROW NEW Progress.Lang.AppError(c-erros, 0). 
                END.
                ELSE DO:
                    
                    FIND FIRST tt-docum-est NO-LOCK NO-ERROR.
                    
                    FIND FIRST docum-est NO-LOCK
                         WHERE docum-est.cod-emitente = tt-docum-est.cod-emitente
                           AND docum-est.nro-docto    = tt-docum-est.nro-docto      
                           AND docum-est.serie-docto  = tt-docum-est.serie-docto      
                           AND docum-est.nat-operacao = tt-docum-est.nat-operacao NO-ERROR.
                    IF NOT AVAIL docum-est THEN
                        UNDO, THROW NEW Progress.Lang.AppError("API de geraá∆o de notas fiscais n∆o retornou erros, porÇm a nota n∆o foi criada. Consulte o suporte.", 0).

                    //Rotina para gerar as duplicatas no RE1001 (Bot∆o Geraá∆o)
                    FIND FIRST natur-oper NO-LOCK
                         WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
                    IF  AVAIL natur-oper
                    AND natur-oper.emite-duplic 
                    THEN
                        RUN rep/re9341.p (INPUT ROWID(docum-est), INPUT YES).
                    
                    //Rotina para substituir a rat-lote gerada pela enviada no JSON (Dep¢sito/Localizaá∆o) -- 18/05/2020
                    FOR EACH tt-rat-lote NO-LOCK:
                        
                        FOR EACH rat-lote EXCLUSIVE-LOCK
                           WHERE rat-lote.cod-emitente = tt-rat-lote.cod-emitente
                             AND rat-lote.serie-docto  = tt-rat-lote.serie-docto
                             AND rat-lote.nro-docto    = tt-rat-lote.nro-docto
                             AND rat-lote.nat-operacao = tt-rat-lote.nat-operacao
                             AND rat-lote.sequencia    = tt-rat-lote.sequencia
                             AND rat-lote.it-codigo    = tt-rat-lote.it-codigo:
                                 
                            DELETE rat-lote.
                        END.
                    END.
    
                    FOR EACH tt-rat-lote NO-LOCK:
                        CREATE rat-lote.
                        BUFFER-COPY tt-rat-lote TO rat-lote.
                    END.
                    
                    RELEASE rat-lote.
                    
/*                     /*--- Notas fiscais referenciadas ---*/                                                                                         */
/*                     IF p-tipo = 4 /*Retorno*/ THEN DO:                                                                                              */
/*                                                                                                                                                     */
/*                         ASSIGN i-seq-adc = 1.                                                                                                       */
/*                                                                                                                                                     */
/*                         FOR EACH ttNFref NO-LOCK:                                                                                                   */
/*                                                                                                                                                     */
/*                             FIND FIRST nota-fiscal NO-LOCK                                                                                          */
/*                                  WHERE nota-fiscal.cod-chave-aces-nf-eletro BEGINS ttNFref.refNFe NO-ERROR.                                         */
/*                             IF AVAIL nota-fiscal THEN DO:                                                                                           */
/*                                                                                                                                                     */
/*                                 CREATE nota-fisc-adc.                                                                                               */
/*                                 ASSIGN nota-fisc-adc.cod-estab                = docum-est.cod-estabel                                               */
/*                                        nota-fisc-adc.cod-serie                = docum-est.serie-docto                                               */
/*                                        nota-fisc-adc.cod-nota-fisc            = docum-est.nro-docto                                                 */
/*                                        nota-fisc-adc.cdn-emitente             = docum-est.cod-emitente                                              */
/*                                        nota-fisc-adc.cod-natur-operac         = docum-est.nat-operacao                                              */
/*                                        nota-fisc-adc.idi-tip-dado             = 3 /*Docto Fiscal Referenciado*/                                     */
/*                                        nota-fisc-adc.num-seq                  = i-seq-adc                                                           */
/*                                        nota-fisc-adc.cod-ser-docto-referado   = nota-fiscal.serie                                                   */
/*                                        nota-fisc-adc.cod-docto-referado       = nota-fiscal.nr-nota-fis                                             */
/*                                        nota-fisc-adc.cdn-emit-docto-referado  = nota-fiscal.cod-emitente                                            */
/*                                        nota-fisc-adc.cod-model-docto-referado = "55"                                                                */
/*                                        nota-fisc-adc.dat-docto-referado       = nota-fiscal.dt-emis-nota                                            */
/*                                        nota-fisc-adc.cod-livre-2              = nota-fiscal.cod-chave-aces-nf-eletro.                               */
/*                                                                                                                                                     */
/*                                 ASSIGN i-seq-adc = i-seq-adc + 1.                                                                                   */
/*                             END.                                                                                                                    */
/*                             ELSE                                                                                                                    */
/*                                 UNDO, THROW NEW Progress.Lang.AppError("N∆o encontrada NF-e referenciada no sistema. Chave: " + ttNFref.refNFe, 0). */
/*                         END.                                                                                                                        */
/*                     END.                                                                                                                            */
                    
                    /*--- Atualizaá∆o do documento ---*/
                    ASSIGN l-ok = TRUE.
                    IF prm-projeto-integrador.log-at-auto-re THEN DO:

                        FIND FIRST int-docum-est EXCLUSIVE-LOCK
                             WHERE int-docum-est.serie-docto  = docum-est.serie-docto
                               AND int-docum-est.nro-docto    = docum-est.nro-docto  
                               AND int-docum-est.cod-emitente = docum-est.cod-emitente
                               AND int-docum-est.nat-operacao = docum-est.nat-operacao NO-ERROR.
                        IF NOT AVAIL int-docum-est THEN DO:
                            CREATE int-docum-est.
                            ASSIGN int-docum-est.serie-docto  = docum-est.serie-docto
                                   int-docum-est.nro-docto    = docum-est.nro-docto  
                                   int-docum-est.cod-emitente = docum-est.cod-emitente
                                   int-docum-est.nat-operacao = docum-est.nat-operacao.
                        END.
                        ASSIGN int-docum-est.cod-msg-devolucao = 508
                               int-docum-est.nota-completa     = YES.
                        // Fim Alteraá‰es Intelbras - Jonatan da Mata - 29/09/2023
            
                        RELEASE int-docum-est.
                        
                        RUN pi-atualiza IN h-docum-est-integrador(INPUT ROWID(docum-est)
                                                                 ,OUTPUT l-ok
                                                                 ,OUTPUT c-erros).
                                                                 
                    END.
                    DEF VAR i-cont AS INT NO-UNDO.
                    DEF VAR l-elimina AS LOG NO-UNDO.
                    IF NOT l-ok OR TRIM(c-erros) <> "" THEN DO:

                        DO i-cont = 1 TO NUM-ENTRIES(c-erros,'|'):
                            IF TRIM(ENTRY(i-cont,c-erros,'|')) <> "Valor total liquido das mercadorias n∆o confere"
                            AND TRIM(ENTRY(i-cont,c-erros,'|')) <> "Valor Total da Nota n∆o confere"
                            AND TRIM(ENTRY(i-cont,c-erros,'|')) <> "Base de IPI calculada difere da somat¢ria dos itens"
                            AND TRIM(ENTRY(i-cont,c-erros,'|')) <> "Valor da base do ICMS n∆o confere"
                            AND TRIM(ENTRY(i-cont,c-erros,'|')) <> "Valor do ICMS n∆o confere" THEN DO:
                                ASSIGN l-elimina = YES.
                            END.
                        END.

                        IF l-elimina THEN DO:
                            RUN pi-elimina IN h-docum-est-integrador(INPUT ROWID(docum-est),
                                                                     OUTPUT l-ok).
                            
                            IF TRIM(c-erros) = "" THEN
                                ASSIGN c-erros = "Ocorreram erros inesperados ao atualizar o documento. Entre em contato com o suporte.".
                                
                            UNDO, THROW NEW Progress.Lang.AppError(c-erros, 0).
                        END.
                    END.
                END.
                
                RETURN ROWID(docum-est).
            END.
            
            CATCH erro AS Progress.Lang.Error:            
                UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1), erro:GetMessageNum(1)).
            END CATCH. 
            FINALLY:
                
                IF VALID-HANDLE(h-docum-est-integrador) THEN DO:
                    DELETE PROCEDURE h-docum-est-integrador.
                    ASSIGN h-docum-est-integrador = ?.
                END.

                RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin176.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin092.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin090.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin404.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin404re.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin367.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi088.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi515.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin0815.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "inbo/boin245na.p").
                
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi613calc2.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "cdp/cdcfgfiscal.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "cdp/cdcfgfiscal-1.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "cnp/cn9174.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "dibo/bodi317im2bra.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "cdp/cdapi1001.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "cdp/cdapi034.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "cdp/cdapi995.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "ivbo/boiv029.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "prgfin/fgl/fgl731za.py").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "prghur/fpp/fp9200.p").
                RUN prmapi/prmapi-fecha-procedure.p(INPUT "prgtec/btb/btb901zo.py").
            END FINALLY.  
        END.     
    END METHOD.   
    
    METHOD PRIVATE VOID EnviarEmailNFComErro(INPUT p-msg-erro AS CHARACTER):
        
        DEFINE VARIABLE c-email-destino AS CHARACTER NO-UNDO.        
        
        FOR EACH usuar_grp_usuar WHERE usuar_grp_usuar.cod_grp_usuar = prm-param-integrador.cod-grp-usuar-int-recebimento NO-LOCK,
            FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = usuar_grp_usuar.cod_usuario NO-LOCK:
            
            IF usuar_mestre.cod_e_mail_local <> "" THEN     
                ASSIGN c-email-destino = c-email-destino + usuar_mestre.cod_e_mail_local + ";".                   
        END. 
        ASSIGN c-email-destino = RIGHT-TRIM(c-email-destino,";").
        
        IF c-email-destino <> "" THEN 
            RUN prmapi/prmapi-mail.p(INPUT c-email-destino,
                                     INPUT "Erro geraá∆o de nota fiscal recebimento - Projeto Integraá∆o " + prm-projeto-integrador.cod-proj-int,
                                     INPUT "Erro na geraá∆o da nota fiscal no recebimento do Projeto Integraá∆o " + prm-projeto-integrador.cod-proj-int + CHR(10) +
                                           "Arquivo: " + c-arquivo-xml + chr(10) +
                                           "Mensagem: " + p-msg-erro,
                                     INPUT "").                                                                         
    END METHOD.
    
    METHOD PRIVATE VOID CriarLogNF(INPUT p-docum-est AS ROWID,
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

        IF p-erros <> "" THEN
            ASSIGN prm-nf-integrador.situacao     = 2
                   prm-nf-integrador.msg-erro     = SUBSTRING(p-erros,1,9000)
                   prm-nf-integrador.cod-estabel  = ""
                   prm-nf-integrador.nr-nota-fis  = ""
                   prm-nf-integrador.serie        = ""
                   prm-nf-integrador.cod-emitente = ?
                   prm-nf-integrador.nat-operacao = "".
                   
        FIND FIRST docum-est WHERE ROWID(docum-est) = p-docum-est NO-LOCK NO-ERROR.
        IF AVAILABLE(docum-est) THEN 
            ASSIGN prm-nf-integrador.cod-estabel  = docum-est.cod-estabel
                   prm-nf-integrador.nr-nota-fis  = docum-est.nro-docto
                   prm-nf-integrador.serie        = docum-est.serie-docto
                   prm-nf-integrador.cod-emitente = docum-est.cod-emitente
                   prm-nf-integrador.nat-operacao = docum-est.nat-operacao
                   prm-nf-integrador.situacao     = 1
                   prm-nf-integrador.msg-erro     = "".       
    END METHOD.
    
    METHOD PRIVATE VOID MoverXMLImportado(INPUT p-tipo AS INTEGER):
        
        /*TIPO    1 - VENDA    */
        /*        2 - CANCELADA*/
        /*        3 - REMESSA  */
        /*        4 - RETORNO  */
        /*        5 - DEVOLUÄ«O*/
        /*        6 - CT-E     */
        
        CASE p-tipo:
            WHEN 4 THEN
                FILE-INFO:FILE-NAME = RIGHT-TRIM(prm-projeto-integrador.dir-nfe-ret, "/") + "/Importados".
            WHEN 5 THEN
                FILE-INFO:FILE-NAME = RIGHT-TRIM(prm-projeto-integrador.dir-nfe-devol, "/") + "/Importados".
            OTHERWISE
                UNDO,THROW NEW Progress.Lang.AppError("Tipo da nota fiscal deve ser de RETORNO (4) ou DEVOLUÄ«O (5). (" + STRING(p-tipo) + ") informado", 0).
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
/*             FIND FIRST docum-est NO-LOCK                                              */
/*                  WHERE docum-est.cod-chave-aces-nf-eletro = ttInfProt.chNFe NO-ERROR. */
/*             IF AVAIL docum-est THEN                                                   */
/*                 RETURN ROWID(docum-est).                                              */
            /* Fim da RemoÁ„o por Rafael Rosa em 06/10/2023 */        
            
            FIND FIRST prm-nf-integrador NO-LOCK
                 WHERE prm-nf-integrador.chave-acesso-nfe = ttInfProt.chNFe NO-ERROR.            
            IF AVAILABLE(prm-nf-integrador) THEN DO:
                
                FIND FIRST docum-est NO-LOCK
                     WHERE docum-est.serie-docto  = prm-nf-integrador.serie
                       AND docum-est.nro-docto    = prm-nf-integrador.nr-nota-fis
                       AND docum-est.cod-emitente = prm-nf-integrador.cod-emitente
                       AND docum-est.nat-operacao = prm-nf-integrador.nat-operacao NO-ERROR.
                IF AVAILABLE(docum-est) THEN
                    RETURN ROWID(docum-est).
            END.                     
        END.

        RETURN ?.
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).               
        END CATCH.
    END METHOD.
    
    METHOD PRIVATE ROWID BuscarEmitenteDoXML():

        DEFINE VARIABLE rw-emitente     AS ROWID                    NO-UNDO.
        DEFINE VARIABLE emit            AS CLASS prmapi.Emitente    NO-UNDO.

        EMPTY TEMP-TABLE tt-emitente.

        CREATE tt-emitente.            
        emit = NEW prmapi.Emitente().
        emit:CarregarEmitenteComDadosDoXML(INPUT DATASET XMLNotaFiscal,
                                           BUFFER tt-emitente).
        FIND FIRST tt-emitente.
        FIND FIRST emitente WHERE emitente.cgc = tt-emitente.cgc NO-LOCK NO-ERROR.
        IF NOT AVAIL emitente THEN
            UNDO, THROW NEW Progress.Lang.AppError("Emitente n∆o localizado com CNPJ/CPF " + tt-emitente.cgc, 0).
        
        RETURN ROWID(emitente).
        
        CATCH erro AS Progress.Lang.Error:                                          
            UNDO, THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.    
    
    DESTRUCTOR PUBLIC NotaRecebimentoIntegrador():
    END DESTRUCTOR.
END CLASS.
