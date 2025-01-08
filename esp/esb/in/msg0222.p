CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                                       */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                                       */
/*                                                                                                            */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                                      */
/* <MENSAGEM>                                                                                                 */
/*   <CABECALHO>                                                                                              */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor>                            */
/*     <NumeroOperacao>262653</NumeroOperacao>                                                                */
/*     <CodigoMensagem>MSG0222</CodigoMensagem>                                                               */
/*     <LoginUsuario>fr049656</LoginUsuario>                                                                  */
/*   </CABECALHO>                                                                                             */
/*   <CONTEUDO>                                                                                               */
/*     <MSG0222>                                                                                              */
/*       <NumeroPedidoCompra>262653</NumeroPedidoCompra>                                                      */
/*       <OrdemCompra>                                                                                        */
/*         <NumeroOrdemCompra xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />         */
/*         <CodigoProduto>4563209</CodigoProduto>                                                             */
/*         <CodigoUnidadeNegocio>SEC</CodigoUnidadeNegocio>                                                   */
/*         <CodigoDepositoOrdem>EXP</CodigoDepositoOrdem>                                                     */
/*         <MatriculaComprador>ev049717</MatriculaComprador>                                                  */
/*         <NumeroOrdemServico xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />        */
/*         <MatriculaRequisitante>ev049717</MatriculaRequisitante>                                            */
/*         <CodigoContaContabil>11308025</CodigoContaContabil>                                                */
/*         <CodigoCentroCusto xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />         */
/*         <CodigoTipoDespesa>2</CodigoTipoDespesa>                                                           */
/*         <NarrativaOrdemCompra xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />      */
/*         <GerarItemFornecedor>false</GerarItemFornecedor>                                                   */
/*         <Cotacao>                                                                                          */
/*           <CodigoUnidadeMedidaFornecedor>PC</CodigoUnidadeMedidaFornecedor>                                */
/*           <PrecoFornecedor>197.473</PrecoFornecedor>                                                       */
/*           <CodigoMoedaEMS>1</CodigoMoedaEMS>                                                               */
/*           <IPIIncluso>false</IPIIncluso>                                                                   */
/*           <AliquotaIPI>0</AliquotaIPI>                                                                     */
/*           <TipoICMS>1</TipoICMS>                                                                           */
/*           <AliquotaICMS>12</AliquotaICMS>                                                                  */
/*           <AliquotaISS>0</AliquotaISS>                                                                     */
/*           <FreteIncluso>false</FreteIncluso>                                                               */
/*           <TaxaFinanceira xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />          */
/*           <EncargosFinanceiros>false</EncargosFinanceiros>                                                 */
/*           <DiasTaxaFinanceira>0</DiasTaxaFinanceira>                                                       */
/*           <PrecoUnitarioFornecedor xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' /> */
/*         </Cotacao>                                                                                         */
/*         <CotacaoItemImportado>                                                                             */
/*           <CodigoIncoterm>FOB</CodigoIncoterm>                                                             */
/*           <CodigoPontoControleBase>3</CodigoPontoControleBase>                                             */
/*           <CodigoFabricante>161953</CodigoFabricante>                                                      */
/*           <PaisOrigem>CHINA</PaisOrigem>                                                                   */
/*           <NCM>23654</NCM>                                                                                 */
/*           <DestaqueNCM>999</DestaqueNCM>                                                                   */
/*           <AliquotaII>20</AliquotaII>                                                                      */
/*           <CodigoItinerario>221</CodigoItinerario>                                                         */
/*           <NVE>NA</NVE>                                                                                    */
/*           <ExTarifario>NA</ExTarifario>                                                                    */
/*           <NecessitaLicencaImportacao>false</NecessitaLicencaImportacao>                                   */
/*           <GATT>false</GATT>                                                                               */
/*           <PercentualGATT xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />          */
/*         </CotacaoItemImportado>                                                                            */
/*         <ParcelaManual>                                                                                    */
/*           <DataParcela>2015-12-30</DataParcela>                                                            */
/*           <QuantidadeParcela>10</QuantidadeParcela>                                                        */
/*         </ParcelaManual>                                                                                   */
/*       </OrdemCompra>                                                                                       */
/*     </MSG0222>                                                                                             */
/*   </CONTEUDO>                                                                                              */
/* </MENSAGEM>".                                                                                              */

/*<CotacaoItemImportado>
            <CodigoIncoterm></CodigoIncoterm>
            <CodigoPontoControleBase></CodigoPontoControleBase>
            <CodigoFabricante></CodigoFabricante>
            <PaisOrigem></PaisOrigem>
            <NCM></NCM>
            <DestaqueNCM></DestaqueNCM>
            <AliquotaII></AliquotaII>
            <CodigoItinerario></CodigoItinerario>
            <NVE></NVE>
            <EXTarifario></EXTarifario>
            <NecessitaLicencaImportacao></NecessitaLicencaImportacao>
            <GATT></GATT>
            <PercentualGATT></PercentualGATT>
        </CotacaoItemImportado>*/

{esp/esb/in/msg0222.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0222, OrdemCompra, Cotacao, CotacaoItemImportado, ParcelaManual
   DATA-RELATION FOR conteudo, MSG0222                 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0222, OrdemCompra              RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR OrdemCompra, Cotacao              RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR OrdemCompra, CotacaoItemImportado RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR OrdemCompra, ParcelaManual        RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0222R1, resultado
   DATA-RELATION FOR conteudor, MSG0222R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0222R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0222R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0222 NO-ERROR.

CREATE conteudor.
CREATE MSG0222R1.
CREATE resultado.

RUN pi-ordem-compra.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.


IF VALID-HANDLE(hboin274sd) THEN DO:
    DELETE PROCEDURE hboin274sd.
                     hboin274sd = ?.
END.

IF VALID-HANDLE(hboin082sd) THEN DO:
    DELETE PROCEDURE hboin082sd.
                     hboin082sd = ?.
END.

IF VALID-HANDLE(hboin356ca) THEN DO:
    DELETE PROCEDURE hboin356ca.
                     hboin356ca = ?.
END.

IF VALID-HANDLE(hboin082ca) THEN DO:
    DELETE PROCEDURE hboin082ca.
                     hboin082ca = ?.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.                                                      */
/* CREATE X-DOCUMENT hDoc.                                                                      */
/* hDoc:LOAD("LONGCHAR", oXML, NO).                                                             */
/* hDoc:SAVE("FILE","C:/temp/xml-saida" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-ordem-compra:
    FIND FIRST pedido-compr NO-LOCK
         WHERE pedido-compr.num-pedido = MSG0222.NumeroPedidoCompra NO-ERROR.
    
    IF NOT AVAIL pedido-compr THEN DO:
        RUN pi-erro (INPUT "NÆo encontrado pedido de compra n£mero: " + STRING(MSG0222.NumeroPedidoCompra)).
        RETURN "NOK".
    END.
    
    IF NOT VALID-HANDLE(hboin274sd) THEN DO:
        RUN inbo/boin274sd.p PERSISTENT SET hboin274sd.
        RUN openQueryStatic IN hboin274sd ( INPUT "Main":U ).
    END. 

    IF NOT VALID-HANDLE(hboin082sd) THEN DO:
        RUN inbo/boin082sd.p PERSISTENT SET hboin082sd.
        RUN openQueryStatic IN hboin082sd (INPUT "Main":U).
    END. 

    IF NOT VALID-HANDLE(hboin356ca) THEN DO:
        RUN inbo/boin356ca.p PERSISTENT SET hboin356ca.
        RUN openQueryStatic IN hboin356ca ( INPUT "Main":U ).
    END. 

    IF NOT VALID-HANDLE(hboin082ca) THEN DO:
        RUN inbo/boin082ca.p PERSISTENT SET hboin082ca.
    END. 
    
    blk_ordem:
    FOR EACH OrdemCompra:
        EMPTY TEMP-TABLE tt-ordem-compra.
        EMPTY TEMP-TABLE tt-prazo-compra.  
        EMPTY TEMP-TABLE tt-cotacao-item.
        EMPTY TEMP-TABLE ttcotacao-item.
        EMPTY TEMP-TABLE RowErrors.
        EMPTY TEMP-TABLE tt-versao-integr.

        CREATE tt-versao-integr.
        ASSIGN tt-versao-integr.cod-versao-integracao = 1.    

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = OrdemCompra.CodigoProduto NO-ERROR.
    
        IF NOT AVAIL ITEM THEN DO:
            RUN pi-erro (INPUT "NÆo encontrado item com o c¢digo: " + STRING(OrdemCompra.CodigoProduto)).
            RETURN "NOK".
        END.

        FIND FIRST Cotacao NO-LOCK NO-ERROR.

        IF NOT AVAIL Cotacao THEN DO:
            RUN pi-erro (INPUT "Dados para cota‡Æo nÆo enviados!").
            RETURN "NOK".
        END.

        FIND FIRST ParcelaManual NO-LOCK NO-ERROR.

        /*InclusÆo*/
        IF OrdemCompra.NumeroOrdemCompra = ? THEN DO:

            IF NOT AVAIL ParcelaManual THEN DO:
                RUN pi-erro (INPUT "NÆo informada parcela para a ordem de compra!").
                RETURN "NOK".
            END.

            IF ParcelaManual.QuantidadeParcela > 9999999.9999 THEN DO:
                RUN pi-erro (INPUT "Nao permitido parcelas com quantidade maior que 9.999.999,9999").
                RETURN "NOK".
            END.
        
            RUN geraNumeroOrdemPedEmerg IN hboin274sd (OUTPUT i-num-ordem,
                                                       OUTPUT TABLE RowErrors).
            
            FIND FIRST RowErrors NO-LOCK NO-ERROR.
            
            IF CAN-FIND (FIRST RowErrors) THEN DO:
                FOR EACH RowErrors NO-LOCK                                                                                                    
                   WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                     AND RowErrors.ErrorSubType = "Error":U:  
                    RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                    UNDO blk_ordem, LEAVE blk_ordem.
                END. 
            END.

            CREATE tt-ordem-compra.
            ASSIGN tt-ordem-compra.ind-tipo-movto = 1 /*InclusÆo*/
                   tt-ordem-compra.numero-ordem   = i-num-ordem
                   tt-ordem-compra.num-pedido     = pedido-compr.num-pedido
                   tt-ordem-compra.cod-emitente   = pedido-compr.cod-emitente
                   tt-ordem-compra.cod-estabel    = pedido-compr.cod-estabel
                   tt-ordem-compra.cod-cond-pag   = pedido-compr.cod-cond-pag
                   tt-ordem-compra.cod-transp     = pedido-compr.cod-transp
                   tt-ordem-compra.data-pedido    = pedido-compr.data-pedido
                   tt-ordem-compra.ep-codigo      = i-ep-codigo-usuario
                   tt-ordem-compra.qt-solic       = ParcelaManual.QuantidadeParcela
                   tt-ordem-compra.data-emissao   = TODAY
                   tt-ordem-compra.data-cotacao   = TODAY
                   tt-ordem-compra.impr-ficha     = NO
                   tt-ordem-compra.l-split        = NO
                   tt-ordem-compra.situacao       = 2.
        END.
        /*Altera‡Æo*/
        ELSE DO:
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = OrdemCompra.NumeroOrdemCompra NO-ERROR.

            IF NOT AVAIL ordem-compra THEN DO:
                RUN pi-erro (INPUT "NÆo encontrada ordem de compra n£mero " + STRING(OrdemCompra.NumeroOrdemCompra)).
                RETURN "NOK".
            END.

            /*informa‡äes da parcela devem vir somente na inclusÆo*/
            IF AVAIL ParcelaManual THEN DO:
                RUN pi-erro (INPUT "Informa‡äes da parcela nÆo podem ser enviadas na altera‡Æo.").
                RETURN "NOK".
            END.

            CREATE tt-ordem-compra.
            BUFFER-COPY ordem-compra TO tt-ordem-compra.
            ASSIGN tt-ordem-compra.ind-tipo-movto = 2 /*Altera‡Æo*/.
        END.
        
        ASSIGN tt-ordem-compra.mo-codigo      = Cotacao.CodigoMoedaEMS
               tt-ordem-compra.it-codigo      = OrdemCompra.CodigoProduto
               tt-ordem-compra.requisitante   = OrdemCompra.MatriculaRequisitante
               tt-ordem-compra.cod-comprado   = OrdemCompra.MatriculaComprador
               tt-ordem-compra.preco-fornec   = Cotacao.PrecoFornecedor 
               tt-ordem-compra.preco-unit     = Cotacao.PrecoFornecedor 
               tt-ordem-compra.tp-despesa     = OrdemCompra.CodigoTipoDespesa
               tt-ordem-compra.aliquota-iss   = Cotacao.AliquotaISS
               tt-ordem-compra.aliquota-ipi   = Cotacao.AliquotaIPI
               tt-ordem-compra.aliquota-icm   = Cotacao.AliquotaICMS
               tt-ordem-compra.contato        = Cotacao.NomeContato
               tt-ordem-compra.nr-dias-taxa   = Cotacao.DiasTaxaFinanceira
               tt-ordem-compra.valor-taxa     = Cotacao.TaxaFinanceira
               tt-ordem-compra.taxa-finan     = Cotacao.EncargosFinanceiros
               tt-ordem-compra.qt-acum-nec    = tt-ordem-compra.qt-solic
               tt-ordem-compra.cod-unid-negoc = OrdemCompra.CodigoUnidadeNegocio /*IF AVAIL item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE ""*/
               tt-ordem-compra.ct-codigo      = OrdemCompra.CodigoContaContabil
               tt-ordem-compra.sc-codigo      = OrdemCompra.CodigoCentroCusto
               tt-ordem-compra.dep-almoxar    = OrdemCompra.CodigoDepositoOrdem
               tt-ordem-compra.ordem-servic   = OrdemCompra.NumeroOrdemServico
               tt-ordem-compra.narrativa      = OrdemCompra.NarrativaOrdemCompra.

        /* vai usar essas informa‡äes da propria mensagem
        RUN buscaInfOrdemLeaveItem IN hboin274sd (INPUT tt-ordem-compra.it-codigo,
                                                  INPUT tt-ordem-compra.cod-estabel,
                                                  INPUT tt-ordem-compra.num-pedido,
                                                  OUTPUT c-discard,
                                                  OUTPUT tt-ordem-compra.ct-codigo,
                                                  OUTPUT tt-ordem-compra.sc-codigo,
                                                  OUTPUT tt-ordem-compra.dep-almoxar,
                                                  OUTPUT i-discard).
        */                                                  
        
        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo    = OrdemCompra.CodigoProduto 
               AND item-fornec-estab.cod-emitente = pedido-compr.cod-emitente 
               AND item-fornec-estab.cod-estabel  = pedido-compr.cod-estabel NO-ERROR.
        
        IF  NOT AVAIL item-fornec-estab
        AND OrdemCompra.GerarItemFornecedor THEN DO:
            CREATE item-fornec-estab.
            ASSIGN item-fornec-estab.it-codigo    = OrdemCompra.CodigoProduto
                   item-fornec-estab.cod-emitente = pedido-compr.cod-emitente 
                   item-fornec-estab.cod-estabel  = pedido-compr.cod-estabel
                   item-fornec-estab.ativo        = YES.
            RELEASE item-fornec-estab.
        END.
        
        FIND FIRST item-fornec EXCLUSIVE-LOCK 
             WHERE item-fornec.it-codigo    = OrdemCompra.CodigoProduto 
               AND item-fornec.cod-emitente = pedido-compr.cod-emitente NO-ERROR.
        
        IF  NOT AVAILABLE item-fornec 
        AND OrdemCompra.GerarItemFornecedor THEN DO:
            CREATE item-fornec.
            ASSIGN item-fornec.it-codigo    = OrdemCompra.CodigoProduto
                   item-fornec.cod-emitente = pedido-compr.cod-emitente
                   item-fornec.item-do-forn = OrdemCompra.CodigoProduto 
                   item-fornec.unid-med-for = Cotacao.CodigoUnidadeMedidaFornecedor
                   item-fornec.fator-conver = 1
                   item-fornec.num-casa-dec = 0
                   item-fornec.ativo        = YES
                   item-fornec.cod-cond-pag = pedido-compr.cod-cond-pag
                   item-fornec.classe-repro = 3
                   item-fornec.aval-insp    = 5
                   item-fornec.idi-tributac-pis    = 2  /*Tributacao PIS Isento*/
                   item-fornec.idi-tributac-cofins = 2. /*Tributacao COFINS Isento*/
            RELEASE item-fornec.
        END.

        FIND FIRST int-item-for-PN NO-LOCK
            WHERE int-item-for-PN.cod-emitente = pedido-compr.cod-emitente
              AND int-item-for-PN.it-codigo    = OrdemCompra.CodigoProduto NO-ERROR.
        IF  NOT AVAIL int-item-for-PN THEN DO:
            CREATE int-item-for-pn.
            ASSIGN int-item-for-PN.cod-emitente = pedido-compr.cod-emitente 
                   int-item-for-PN.it-codigo    = OrdemCompra.CodigoProduto 
                   int-item-for-PN.item-do-forn = OrdemCompra.CodigoProduto. 

        END.

        /*S¢ gera parcela para cria‡Æo da ordem*/
        IF tt-ordem-compra.ind-tipo-movto = 1 THEN DO:

            {cdp/cd9950.i item.un 
                          Cotacao.CodigoUnidadeMedidaFornecedor
                          pedido-compr.cod-emitente}

            assign de-indice = 1 when (de-indice = 0 or de-indice = ?). 
        
            CREATE tt-prazo-compra.
            ASSIGN tt-prazo-compra.ind-tipo-movto = tt-ordem-compra.ind-tipo-movto
                   tt-prazo-compra.numero-ordem   = tt-ordem-compra.numero-ordem 
                   tt-prazo-compra.parcela        = 1
                   tt-prazo-compra.quantidade     = tt-ordem-compra.qt-solic
                   tt-prazo-compra.un             = item.un
                   tt-prazo-compra.data-entrega   = ParcelaManual.DataParcela
                   tt-prazo-compra.situacao       = tt-ordem-compra.situacao
                   tt-prazo-compra.data-alter     = TODAY
                   tt-prazo-compra.it-codigo      = tt-ordem-compra.it-codigo
                   tt-prazo-compra.qtd-a-ped-forn = tt-prazo-compra.quantidade * de-indice
                   tt-prazo-compra.qtd-do-forn    = tt-prazo-compra.quantidade * de-indice
                   tt-prazo-compra.qtd-sal-forn   = tt-prazo-compra.quantidade * de-indice
                   tt-prazo-compra.quant-saldo    = tt-prazo-compra.quantidade
                   tt-prazo-compra.quantid-orig   = tt-prazo-compra.quantidade.

            RUN calculaProximaParcelaPrazoCompra IN hboin356ca (INPUT  tt-ordem-compra.numero-ordem,
                                                                INPUT  tt-ordem-compra.it-codigo,
                                                                INPUT  tt-ordem-compra.cod-estabel,
                                                                INPUT  pedido-compr.cod-emitente,
                                                                OUTPUT tt-prazo-compra.parcela,
                                                                OUTPUT tt-prazo-compra.un,
                                                                OUTPUT tt-prazo-compra.data-entrega).
            
            ASSIGN tt-prazo-compra.data-entrega = ParcelaManual.DataParcela.
        END.
        ELSE DO:
            FOR EACH prazo-compra NO-LOCK
               WHERE prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem:
                CREATE tt-prazo-compra.
                BUFFER-COPY prazo-compra TO tt-prazo-compra.
                ASSIGN tt-prazo-compra.ind-tipo-movto = tt-ordem-compra.ind-tipo-movto.
            END.
        END.
        
        CREATE tt-cotacao-item.
        ASSIGN tt-cotacao-item.ind-tipo-movto = tt-ordem-compra.ind-tipo-movto.

        /*Na inclusÆo seta defaults*/
        IF tt-ordem-compra.ind-tipo-movto = 1 THEN DO:
            RUN setDefaultsCotacao.
        END.
        /*Na altera‡Æo copia o registro atual*/
        ELSE DO:
            FIND FIRST cotacao-item NO-LOCK
                 WHERE cotacao-item.cot-aprovada = YES
                   AND cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.

            IF AVAIL cotacao-item THEN
                BUFFER-COPY cotacao-item TO ttcotacao-item.
            ELSE 
                RUN setDefaultsCotacao.
        END.
        
        FIND FIRST ttcotacao-item NO-ERROR.
        
        ASSIGN ttcotacao-item.preco-fornec = tt-ordem-compra.preco-fornec
               ttcotacao-item.preco-unit   = tt-ordem-compra.preco-fornec
               ttcotacao-item.codigo-ipi   = Cotacao.IPIIncluso
               ttcotacao-item.aliquota-ipi = Cotacao.AliquotaIPI 
               ttcotacao-item.codigo-icm   = Cotacao.TipoICMS
               ttcotacao-item.aliquota-icm = Cotacao.AliquotaICMS
               ttcotacao-item.aliquota-iss = Cotacao.AliquotaISS
               ttcotacao-item.taxa-finan   = Cotacao.EncargosFinanceiros
               ttcotacao-item.nr-dias-taxa = Cotacao.DiasTaxaFinanceira
               ttcotacao-item.valor-taxa   = Cotacao.TaxaFinanceira
               ttcotacao-item.numero-ordem = tt-ordem-compra.numero-ordem
               ttcotacao-item.it-codigo    = tt-ordem-compra.it-codigo
               ttcotacao-item.un           = Cotacao.CodigoUnidadeMedidaFornecedor
               ttcotacao-item.mo-codigo    = Cotacao.CodigoMoedaEMS
               ttcotacao-item.cod-emitente = pedido-compr.cod-emitente
               ttcotacao-item.cod-comprado = tt-ordem-compra.cod-comprado
               ttcotacao-item.cod-transp   = tt-ordem-compra.cod-transp
               ttcotacao-item.hora-atualiz = STRING(time, "hh:mm:ss")
               ttcotacao-item.cot-aprovada = YES
               ttcotacao-item.contato      = Cotacao.NomeContato
               ttcotacao-item.usuario      = c-seg-usuario
               ttcotacao-item.prazo-entreg = Cotacao.PrazoEntrega
               ttcotacao-item.frete        = Cotacao.FreteIncluso
               ttcotacao-item.valor-frete  = Cotacao.ValorFrete.

        ASSIGN de-indice = 1.
    
        RUN calculaPrecoUnitFornecedorCotacao IN hboin082ca (INPUT NO,                            
                                                             INPUT tt-ordem-compra.numero-ordem,  
                                                             INPUT-OUTPUT TABLE ttcotacao-item). 
        
        FIND FIRST ttcotacao-item NO-ERROR.                                                       

        {cdp/cd9950.i item.un
                      ttcotacao-item.un
                      ttcotacao-item.cod-emitente}

        ASSIGN de-indice = 1 WHEN (de-indice = 0 OR de-indice = ?). 
        
        BUFFER-COPY ttcotacao-item TO tt-cotacao-item.
        
        ASSIGN tt-cotacao-item.preco-unit = ttcotacao-item.pre-unit-for * de-indice.

        IF ttcotacao-item.pre-unit-for = ? THEN DO:
            RUN pi-erro (INPUT "NÆo foi poss¡vel encontrar tabela").
            UNDO blk_ordem, LEAVE blk_ordem.
        END.
        
        EMPTY TEMP-TABLE tt-erros-geral.
        EMPTY TEMP-TABLE RowErrors.
        
        RUN ccp/ccapi302.p (INPUT  TABLE tt-versao-integr,
                            OUTPUT TABLE tt-erros-geral,
                            INPUT  TABLE tt-ordem-compra,
                            INPUT  TABLE tt-prazo-compra,        
                            INPUT  TABLE tt-cotacao-item,
                                 &if DEFINED(bf_mat_despesa_fase_II) &then
                                 INPUT TABLE tt-desp-cotacao-item,
                                 &endif
                                 &if '{&bf_mat_versao_ems}' >= '2.04' &then
                                 INPUT TABLE tt-matriz-rat-med,
                                &endif
                            INPUT "MAT038").

        FOR EACH tt-erros-geral:
            RUN pi-erro (INPUT tt-erros-geral.des-erro + " " + STRING(tt-erros-geral.cod-erro)).
        END.

        IF CAN-FIND (FIRST tt-erro) THEN DO:
            UNDO blk_ordem, LEAVE blk_ordem.
        END.
        ELSE DO:
            FOR FIRST cotacao-item NO-LOCK
                WHERE cotacao-item.cot-aprovada = YES
                  AND cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem:
        
                FIND FIRST ordem-compra EXCLUSIVE-LOCK
                     WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.
        
                IF AVAIL ordem-compra THEN
                    ASSIGN ordem-compra.pre-unit-for = cotacao-item.pre-unit-for
                           ordem-compra.preco-orig   = cotacao-item.pre-unit-for
                           ordem-compra.preco-unit   = cotacao-item.preco-unit.
             END.  
        
             FIND FIRST emitente NO-LOCK
                  WHERE emitente.cod-emitente = tt-ordem-compra.cod-emitente NO-ERROR.

             IF emitente.natureza = 3 
             OR emitente.natureza = 4 THEN DO:
                FIND FIRST CotacaoItemImportado NO-LOCK NO-ERROR.

                IF NOT AVAIL CotacaoItemImportado THEN DO:
                    RUN pi-erro (INPUT "NÆo encontrado cota‡Æo importa‡Æo para a ordem: " + STRING(tt-ordem-compra.numero-ordem)).
                    UNDO blk_ordem, LEAVE blk_ordem.
                END.
        
                EMPTY TEMP-TABLE ttcotacao-item.
        
                FOR EACH cotacao-item NO-LOCK
                   WHERE cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem:
                    CREATE ttcotacao-item.
                    BUFFER-COPY cotacao-item TO ttcotacao-item.
                    ASSIGN ttcotacao-item.r-rowid = ROWID(cotacao-item).
                END.
        
                RUN piImportacao.

                IF RETURN-VALUE <> "OK" THEN
                    UNDO blk_ordem, LEAVE blk_ordem.
             END.   
        END.
    END.
    
    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".
    ELSE DO:
        FIND FIRST processo-imp NO-LOCK
             WHERE processo-imp.num-pedido  = pedido-compr.num-pedido NO-ERROR.

        FIND FIRST int-processo-imp EXCLUSIVE-LOCK
             WHERE int-processo-imp.cod-estabel = processo-imp.cod-estabel
               AND int-processo-imp.nr-proc-imp = processo-imp.nr-proc-imp NO-ERROR.

        IF NOT AVAIL int-processo-imp THEN DO:
            CREATE int-processo-imp.
            ASSIGN int-processo-imp.cod-estabel = processo-imp.cod-estabel
                   int-processo-imp.nr-proc-imp = processo-imp.nr-proc-imp.
        END.

        ASSIGN int-processo-imp.log-libera-itinerario = MSG0222.LogLiberaItinerarioComex.

        /*Grava dados de retorno*/
        ASSIGN msg0222r1.NumeroPedidoCompra = tt-ordem-compra.num-pedido
               msg0222r1.NumeroOrdemCompra  = tt-ordem-compra.numero-ordem.

        RETURN "OK".
    END.
END.

PROCEDURE piImportacao:

    DEF VAR de-aliq-ii  AS DEC     NO-UNDO.
    DEF VAR de-aliq-ipi AS DEC     NO-UNDO.
    DEF VAR l-regime    AS LOGICAL NO-UNDO.

    FIND FIRST ttcotacao-item NO-ERROR.

    FIND FIRST item NO-LOCK
         WHERE item.it-codigo = ttcotacao-item.it-codigo NO-ERROR.

    FOR FIRST param-imp NO-LOCK:
    END.

    FOR EACH ttcotacao-item:
        FOR FIRST cotacao-item EXCLUSIVE-LOCK
            WHERE ROWID(cotacao-item) = ttcotacao-item.r-rowid:

            FIND FIRST mgcad.pais NO-LOCK
                 WHERE mgcad.pais.nome-pais = CotacaoItemImportado.PaisOrigem NO-ERROR.

            IF NOT AVAIL pais THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado pa¡s " + CotacaoItemImportado.PaisOrigem).
                RETURN "NOK".
            END.
            
            ASSIGN cotacao-item.cod-incoterm          = CotacaoItemImportado.CodigoIncoterm
                   cotacao-item.Cod-pto-contr-base    = CotacaoItemImportado.CodigoPontoControleBase
                   cotacao-item.int-1                 = CotacaoItemImportado.CodigoItinerario
                   cotacao-item.mapa-cotacao          = 0   
                   OVERLAY(cotacao-item.char-1, 1, 2) = "0"
                   OVERLAY(cotacao-item.char-1,21,20) = STRING(CotacaoItemImportado.CodigoIncoterm, "x(20)")
                   OVERLAY(cotacao-item.char-1,41, 5) = STRING(CotacaoItemImportado.CodigoPontoControleBase, "99999")
                   OVERLAY(cotacao-item.char-1,81,10) = STRING(CotacaoItemImportado.NCM, "x(10)")
                   OVERLAY(cotacao-item.char-2,41, 9) = STRING(CotacaoItemImportado.CodigoFabricante)
                   OVERLAY(cotacao-item.char-2,81, 8) = STRING(TODAY)
                   cotacao-item.aliquota-ipi          = Cotacao.AliquotaIPI
                   cotacao-item.aliquota-ii           = CotacaoItemImportado.AliquotaII
                   OVERLAY(cotacao-item.char-1,61,20) = STRING(CotacaoItemImportado.AliquotaII)
                   cotacao-item.regime-impot          = 0
                   cotacao-item.cdn-pais-orig         = pais.cod-pais
                   cotacao-item.class-fiscal          = CotacaoItemImportado.NCM.       

            FIND FIRST int-cotacao-item OF cotacao-item EXCLUSIVE NO-ERROR.

            IF NOT AVAIL int-cotacao-item THEN DO:
                CREATE int-cotacao-item.
                ASSIGN int-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                       int-cotacao-item.cod-emitente = cotacao-item.cod-emitente
                       int-cotacao-item.it-codigo    = cotacao-item.it-codigo
                       int-cotacao-item.seq-cotac    = cotacao-item.seq-cotac.
            END.
            
            ASSIGN int-cotacao-item.destaque         = CotacaoItemImportado.DestaqueNCM
                   int-cotacao-item.nve              = CotacaoItemImportado.NVE
                   int-cotacao-item.ex-tarifario     = CotacaoItemImportado.EXTarifario
                   int-cotacao-item.log-necessita-li = CotacaoItemImportado.NecessitaLicencaImportacao
                   int-cotacao-item.log-gatt         = CotacaoItemImportado.GATT
                   int-cotacao-item.perc-gatt        = CotacaoItemImportado.PercentualGATT.

            RELEASE int-cotacao-item.
        END.               
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE setDefaultsCotacao:
    DEF VAR l-discard      AS LOG  NO-UNDO.
    DEF VAR c-cod-comprado AS CHAR NO-UNDO.
    
    RUN emptyRowObject IN hboin082sd.
    ASSIGN c-cod-comprado = tt-ordem-compra.cod-comprado.

    RUN preparaCotacaoOrdemCompraPedEmerg IN hboin082sd (INPUT tt-ordem-compra.numero-ordem,  
                                                         INPUT pedido-compr.num-pedido, 
                                                         INPUT tt-ordem-compra.cod-emitente,  
                                                         INPUT tt-ordem-compra.it-codigo,
                                                         INPUT tt-ordem-compra.cod-estabel,
                                                         INPUT tt-ordem-compra.qt-solic,
                                                         INPUT tt-prazo-compra.data-entrega,  
                                                         INPUT-OUTPUT c-cod-comprado,
                                                         OUTPUT l-discard,
                                                         OUTPUT l-discard,
                                                         OUTPUT l-discard,
                                                         OUTPUT l-discard,
                                                         OUTPUT l-discard,
                                                         OUTPUT l-discard,  
                                                         OUTPUT TABLE ttcotacao-item).
END PROCEDURE.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    

