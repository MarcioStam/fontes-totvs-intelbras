CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>276381-fr049656</NumeroOperacao>                            */
/*     <CodigoMensagem>MSG0208</CodigoMensagem>                                    */
/*     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0208>                                                                   */
/*       <NumeroPedidoCompra>276381</NumeroPedidoCompra>                           */
/*       <NumeroEmbarque>489189m</NumeroEmbarque>                                  */
/*       <MatriculaUsuario>fr049656</MatriculaUsuario>                             */
/*     </MSG0208>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

DEFINE BUFFER b-ordens-embarque    FOR ordens-embarque.
DEFINE BUFFER b-historico-embarque FOR historico-embarque.
DEFINE BUFFER b3-historico-embarque FOR historico-embarque.

DEFINE QUERY qr-pedido-compr
FOR pedido-compr, ordem-compra, prazo-compra.

DEFINE BUFFER b-emitente  FOR emitente. /* NomeAgenteCargas         */ 
DEFINE BUFFER b1-emitente FOR emitente. /* NomeCorretorCambio       */ 
DEFINE BUFFER b2-emitente FOR emitente. /* NomeDespachanteExterior  */ 
DEFINE BUFFER b3-emitente FOR emitente. /* NomeSeguradora           */ 
DEFINE BUFFER b4-emitente FOR emitente. /* NomeDespachante          */ 
DEFINE BUFFER b5-emitente FOR emitente. /* NomeDespachante          */ 
DEFINE BUFFER b6-emitente FOR emitente. 

DEFINE VARIABLE de-indice AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-id-relac  AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-ex-tarifario AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-dias-total AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-bocx230                AS HANDLE      NO-UNDO.


{include/boerrtab.i}
{esp/esb/in/msg0208.i}
{esp/es0018.i}
{esp/esb/esesb000fn1.i}

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, MSG0208
   DATA-RELATION FOR conteudo, MSG0208   RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0208R1, resultado, Pedido_R1, ProcessoImportacao_R1, Ordem_R1, Cotacao_R1, CotacaoItemImportado_R1, Parcela_R1, InspecaoAgendada
   DATA-RELATION FOR conteudor, MSG0208R1               RELATION-FIELDS (idm, idm)                               NESTED
   DATA-RELATION FOR MSG0208R1, Pedido_R1               RELATION-FIELDS (idm, idm)                               NESTED
   DATA-RELATION FOR Pedido_R1, ProcessoImportacao_R1   RELATION-FIELDS (NumeroPedidoCompra, NumeroPedidoCompra) NESTED
   DATA-RELATION FOR Pedido_R1, Ordem_R1                RELATION-FIELDS (NumeroPedidoCompra, NumeroPedidoCompra) NESTED
   DATA-RELATION FOR Ordem_R1,  Cotacao_R1              RELATION-FIELDS (NumeroOrdemCompra, NumeroOrdemCompra)   NESTED
   DATA-RELATION FOR Ordem_R1,  CotacaoItemImportado_R1 RELATION-FIELDS (NumeroOrdemCompra, NumeroOrdemCompra)   NESTED
   DATA-RELATION FOR Ordem_R1,  Parcela_R1              RELATION-FIELDS (NumeroOrdemCompra, NumeroOrdemCompra)   NESTED
   DATA-RELATION FOR Parcela_R1, InspecaoAgendada       RELATION-FIELDS (id-relac, id-relac)   NESTED
   DATA-RELATION FOR MSG0208R1, resultado               RELATION-FIELDS (idm, idm)                               NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0208R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".
FIND FIRST MSG0208 NO-ERROR.

CREATE conteudor.
CREATE MSG0208R1.
CREATE resultado.

IF NOT VALID-HANDLE(h-bocx230) THEN DO:
   RUN cxbo/bocx230a.p persistent set h-bocx230.
END.

RUN pi-gera-dados.

IF VALID-HANDLE(h-bocx230) THEN DO:
    delete procedure h-bocx230.
END. 

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-gera-dados:

    ASSIGN MSG0208R1.ExibePrecos = fnExibePrecos(MSG0208.MatriculaUsuario).
    
    OPEN QUERY qr-pedido-compr
    FOR EACH pedido-compr NO-LOCK
       WHERE pedido-compr.num-pedido = MSG0208.NumeroPedidoCompra,
        EACH ordem-compra NO-LOCK OUTER-JOIN
       WHERE ordem-compra.num-pedido = pedido-compr.num-pedido,
        EACH prazo-compra NO-LOCK OUTER-JOIN
       WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem.

    blk_repeat:
    REPEAT:
        GET NEXT qr-pedido-compr.
        IF NOT AVAIL pedido-compr THEN
            LEAVE blk_repeat.

        RUN pi-cria-pedido.
        IF RETURN-VALUE <> "OK" THEN
            RETURN "NOK".

        RUN pi-cria-processo-importacao.
        IF RETURN-VALUE <> "OK" THEN
            RETURN "NOK".

        IF AVAIL ordem-compra THEN DO:
            RUN pi-cria-ordem.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
    
            RUN pi-cria-cotacao.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.

        IF AVAIL prazo-compra THEN DO:
            RUN pi-cria-parcela.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END.
    

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-cria-pedido:

    DEFINE VARIABLE c-tipo-pedido AS CHARACTER NO-UNDO.

    IF NOT CAN-FIND (FIRST Pedido_R1
                     WHERE Pedido_R1.NumeroPedidoCompra = pedido-compr.num-pedido) THEN DO:

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.
        
        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = pedido-compr.responsavel NO-ERROR.

        FIND FIRST cond-pagto NO-LOCK
             WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-ERROR.

        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = pedido-compr.cod-estabel NO-ERROR.

        FIND FIRST int-pedido-compr NO-LOCK
             WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-ERROR.

        FIND FIRST transporte NO-LOCK
             WHERE transporte.cod-transp = pedido-compr.cod-transp NO-ERROR.

        FIND FIRST ordens-embarque NO-LOCK
             WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
               AND ordens-embarque.parcela      = prazo-compra.parcela 
               AND ordens-embarque.embarque     = MSG0208.NumeroEmbarque
            NO-ERROR.

        FIND FIRST embarque-imp NO-LOCK
             WHERE embarque-imp.embarque = MSG0208.NumeroEmbarque NO-ERROR.

        FIND FIRST ext-embarque-imp NO-LOCK
             WHERE ext-embarque-imp.embarque = MSG0208.NumeroEmbarque NO-ERROR.

        FIND FIRST processo-imp NO-LOCK
             WHERE processo-imp.num-pedido  = pedido-compr.num-pedido NO-ERROR.

        FIND FIRST int-processo-imp NO-LOCK
             WHERE int-processo-imp.cod-estabel = processo-imp.cod-estabel
               AND int-processo-imp.nr-proc-imp = processo-imp.nr-proc-imp NO-ERROR.
        
        IF AVAIL int-pedido-compr THEN DO:
            CASE int-pedido-compr.tp-pedido : 
                WHEN 1 THEN
                    ASSIGN c-tipo-pedido = "Amostra".
                WHEN 2 THEN 
                    ASSIGN c-tipo-pedido = "Automtico".
                WHEN 3 THEN 
                    ASSIGN c-tipo-pedido = "Comum".
                WHEN 4 THEN 
                    ASSIGN c-tipo-pedido = "Homologao".
                WHEN 5 THEN 
                    ASSIGN c-tipo-pedido = "Independente".
                WHEN 6 THEN 
                    ASSIGN c-tipo-pedido = "Ressarcimento".
                WHEN 7 THEN 
                    ASSIGN c-tipo-pedido = "Spot".
                WHEN 8 THEN 
                    ASSIGN c-tipo-pedido = "Troca de Modal".
                WHEN 9 THEN 
                    ASSIGN c-tipo-pedido = "Para Manaus".
                WHEN 10 THEN 
                    ASSIGN c-tipo-pedido = "CKD Comum".
                WHEN 11 THEN 
                    ASSIGN c-tipo-pedido = "CKD Amostra".
                WHEN 12 THEN 
                    ASSIGN c-tipo-pedido = "Para Engesul".
                WHEN 13 THEN 
                    ASSIGN c-tipo-pedido = "Para Automatiza".
                WHEN 14 THEN 
                    ASSIGN c-tipo-pedido = "Back to back".
                WHEN 15 THEN
                    ASSIGN c-tipo-pedido = "Compra Normal".
                WHEN 16 THEN
                    ASSIGN c-tipo-pedido = "Compra Delegada".
                WHEN 17 THEN
                    ASSIGN c-tipo-pedido = "Regulariza‡Æo".
                WHEN 18 THEN
                    ASSIGN c-tipo-pedido = "Compra Estoque Indiretos".
                WHEN 19 THEN
                    ASSIGN c-tipo-pedido = "Amostra OEM".
                WHEN 20 THEN
                    ASSIGN c-tipo-pedido = "Amostra MP".
                WHEN 21 THEN
                    ASSIGN c-tipo-pedido = "Produtos 495".
                WHEN 22 THEN
                    ASSIGN c-tipo-pedido = "Produtos 198".
                WHEN 23 THEN
                    ASSIGN c-tipo-pedido = "Spare Part".
                WHEN 24 THEN
                    ASSIGN c-tipo-pedido = "Licen‡a".
            END CASE.
        END.        

        CREATE Pedido_R1.
        ASSIGN Pedido_R1.NumeroPedidoCompra            = pedido-compr.num-pedido
               Pedido_R1.DataPedido                    = pedido-compr.data-pedido
               Pedido_R1.CodigoFornecedorEMS           = pedido-compr.cod-emitente
               Pedido_R1.NomeAbreviadoFornecedor       = IF AVAIL emitente THEN emitente.nome-abrev ELSE "" 
               Pedido_R1.CGCFornecedor                 = IF AVAIL emitente THEN emitente.cgc ELSE "" 
               Pedido_R1.SituacaoAceitePedido          = IF AVAIL int-pedido-compr THEN  int-pedido-compr.SituacaoAceitePedido ELSE 0  
               Pedido_R1.MotivoRejeicao                = IF AVAIL int-pedido-compr THEN  int-pedido-compr.MotivoRejeicao       ELSE "" 
               Pedido_R1.CodigoCondicaoPagamento       = pedido-compr.cod-cond-pag
               Pedido_R1.NomeCondicaoPagamento         = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
               Pedido_R1.CodigoEstabelecimentoEntrega  = pedido-compr.end-entrega
               Pedido_R1.CodigoEstabelecimentoCobranca = pedido-compr.end-cobranca
               Pedido_R1.MatriculaResponsavel          = pedido-compr.responsavel 
               Pedido_R1.NomeResponsavel               = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "" 
               Pedido_R1.CodigoTipoPedido              = IF AVAIL int-pedido-compr THEN int-pedido-compr.tp-pedido ELSE 0
               Pedido_R1.NomeTipoPedido                = c-tipo-pedido 
               Pedido_R1.PedidoEmergencial             = pedido-compr.emergencial
               Pedido_R1.CodigoCKD                     = IF AVAIL int-pedido-compr THEN int-pedido-compr.cod-produto-ckd ELSE ?
               Pedido_R1.QuantidadeCKD                 = IF AVAIL int-pedido-compr THEN int-pedido-compr.qtd-pedido-ckd ELSE ?
               Pedido_R1.NaturezaPedido                = pedido-compr.natureza
               Pedido_R1.TipoFrete                     = pedido-compr.frete
               Pedido_R1.CodigoTransportadora          = pedido-compr.cod-transp
               Pedido_R1.NomeTransportadora            = IF AVAIL transporte THEN transporte.nome ELSE ""
               Pedido_R1.CodigoViaTransporte           = pedido-compr.via-transp
               Pedido_R1.Narrativa                     = pedido-compr.comentarios
               Pedido_R1.CodigoMensagemPedido          = pedido-compr.cod-mensagem
               Pedido_R1.SituacaoPedidoCompra          = pedido-compr.situacao
               Pedido_R1.LogEnvioComex                 = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.log-envio-comex ELSE NO
               Pedido_R1.logLiberaItinerarioComex      = IF AVAIL int-processo-imp THEN int-processo-imp.log-libera-itinerario ELSE YES
//               Pedido_R1.FinalidadeCourier             = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.finalidade-currier ELSE 0
               .

        FOR EACH texto-follow-up NO-LOCK
           WHERE texto-follow-up.num-pedido = pedido-compr.num-pedido
            BREAK BY texto-follow-up.seq-narra DESC:

            ASSIGN Pedido_R1.HistoricoPedidoCompra = Pedido_R1.HistoricoPedidoCompra + texto-follow-up.des-narrativa + CHR(10) + CHR(10).  
        END.
               
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-cria-processo-importacao:

    IF NOT CAN-FIND (FIRST ProcessoImportacao_R1
                     WHERE ProcessoImportacao_R1.NumeroProcessoImportacao  = processo-imp.nr-proc-imp) THEN DO:
    
        FIND FIRST processo-imp NO-LOCK
             WHERE processo-imp.num-pedido = pedido-compr.num-pedido NO-ERROR.
    
        IF AVAIL processo-imp THEN DO:
            FIND FIRST b4-emitente NO-LOCK
                 WHERE b4-emitente.cod-emitente = processo-imp.cod-despachante NO-ERROR.
    
            FIND FIRST b-emitente NO-LOCK
                 WHERE b-emitente.cod-emitente = processo-imp.cod-agente NO-ERROR.
    
            FIND FIRST b1-emitente NO-LOCK
                 WHERE b1-emitente.cod-emitente = processo-imp.cdn-corretor-cambio-import NO-ERROR.
    
            FIND FIRST b2-emitente NO-LOCK
                 WHERE b2-emitente.cod-emitente = processo-imp.cdn-despa-exter-import NO-ERROR.
    
            FIND FIRST b3-emitente NO-LOCK
                 WHERE b3-emitente.cod-emitente = processo-imp.cdn-segurad-import NO-ERROR.

            FIND FIRST b6-emitente NO-LOCK
                 WHERE b6-emitente.cod-emitente = processo-imp.cdn-corretor-import NO-ERROR.
    
            FIND FIRST itinerario NO-LOCK
                 WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-ERROR.
    
            FIND FIRST int-processo-imp NO-LOCK
                 WHERE int-processo-imp.cod-estabel = processo-imp.cod-estabel
                   AND int-processo-imp.nr-proc-imp = processo-imp.nr-proc-imp NO-ERROR.

            CREATE ProcessoImportacao_R1.
            ASSIGN ProcessoImportacao_R1.NumeroPedidoCompra        = pedido-compr.num-pedido 
                   ProcessoImportacao_R1.NumeroProcessoImportacao  = processo-imp.nr-proc-imp
                   ProcessoImportacao_R1.DataEmissao               = processo-imp.dt-emissao
                   ProcessoImportacao_R1.CodigoDespachante         = processo-imp.cod-despachante
                   ProcessoImportacao_R1.NomeDespachante           = IF AVAIL b4-emitente THEN b4-emitente.nome-abrev ELSE ""
                   ProcessoImportacao_R1.CodigoAgenteCargas        = processo-imp.cod-agente
                   ProcessoImportacao_R1.NomeAgenteCargas          = IF AVAIL b-emitente THEN b-emitente.nome-abrev ELSE ""
                   ProcessoImportacao_R1.CodigoItinerario          = processo-imp.cod-itiner
                   ProcessoImportacao_R1.DescricaoItinerario       = IF AVAIL itinerario THEN itinerario.descricao ELSE ""
                   ProcessoImportacao_R1.CodigoIdioma              = processo-imp.cod-idioma
                   ProcessoImportacao_R1.CodigoCorretorCambio      = processo-imp.cdn-corretor-cambio-import
                   ProcessoImportacao_R1.NomeCorretorCambio        = IF AVAIL b1-emitente THEN b1-emitente.nome-abrev ELSE ""
                   ProcessoImportacao_R1.CodigoDespachanteExterior = processo-imp.cdn-despa-exter-import
                   ProcessoImportacao_R1.NomeDespachanteExterior   = IF AVAIL b2-emitente THEN b2-emitente.nome-abrev ELSE "" 
                   ProcessoImportacao_R1.CodigoSeguradora          = processo-imp.cdn-segurad-import
                   ProcessoImportacao_R1.NomeSeguradora            = IF AVAIL b3-emitente THEN b3-emitente.nome-abrev ELSE "" 
                   ProcessoImportacao_R1.CodigoCorretorSeguro      = processo-imp.cdn-corretor-import
                   ProcessoImportacao_R1.NomeCorretorSeguro        = IF AVAIL b6-emitente THEN b6-emitente.nome-abrev ELSE "" 
                   ProcessoImportacao_R1.NomeDestino               = IF AVAIL int-processo-imp THEN int-processo-imp.NomeDestino ELSE "".
        END.
    END.

    RETURN "OK".
        
END PROCEDURE.

PROCEDURE pi-cria-ordem:

    DEFINE BUFFER b_usuar_mestre FOR usuar_mestre.

    IF NOT CAN-FIND (FIRST Ordem_R1
                     WHERE Ordem_R1.NumeroOrdem = ordem-compra.numero-ordem) THEN DO:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

        FIND FIRST int-item NO-LOCK
             WHERE int-item.it-codigo = ordem-compra.it-codigo NO-ERROR.

        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo 
               AND item-fornec-estab.cod-emitente = pedido-compr.cod-emitente
               AND item-fornec-estab.cod-estabel  = pedido-compr.cod-estabel NO-ERROR.

        FIND FIRST int-item-fornec-estab NO-LOCK
             WHERE int-item-fornec-estab.it-codigo    = ordem-compra.it-codigo 
               AND int-item-fornec-estab.cod-emitente = pedido-compr.cod-emitente
               AND int-item-fornec-estab.cod-estabel  = pedido-compr.cod-estabel NO-ERROR.

        FIND FIRST int-item-uni-estab
             WHERE int-item-uni-estab.cod-estabel = pedido-compr.cod-estabel
               AND int-item-uni-estab.it-codigo   = ordem-compra.it-codigo  NO-ERROR.

        FIND FIRST int-item-for-PN NO-LOCK
            WHERE int-item-for-PN.cod-emitente = pedido-compr.cod-emitente
              AND int-item-for-PN.it-codigo    = ordem-compra.it-codigo NO-ERROR.

        IF  AVAIL int-item-for-PN THEN
            FIND FIRST item-fabric NO-LOCK
                 WHERE item-fabric.it-codigo          = int-item-for-PN.it-codigo
                   AND STRING(item-fabric.cod-fabric) = int-item-for-PN.item-do-forn NO-ERROR.

        FIND FIRST cotacao-item NO-LOCK
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.

        FIND FIRST int-cotacao-item NO-LOCK
             WHERE int-cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND int-cotacao-item.cod-emitente = pedido-compr.cod-emitente
               AND int-cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.

        FIND FIRST deposito NO-LOCK
             WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-ERROR.

        IF AVAIL item-fabric THEN
            FIND FIRST fabricante NO-LOCK
                 WHERE fabricante.cod-fabric = item-fabric.cod-fabric NO-ERROR.

        FIND FIRST unid-negoc NO-LOCK
             WHERE unid-negoc.cod-unid-negoc = ordem-compra.cod-unid-negoc NO-ERROR.

        FIND FIRST moeda NO-LOCK
             WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-ERROR.

        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = ordem-compra.cod-comprado NO-ERROR.

        FIND FIRST b_usuar_mestre NO-LOCK
             WHERE b_usuar_mestre.cod_usuario = ordem-compra.requisitante NO-ERROR.

         FIND FIRST tipo-rec-desp NO-LOCK
              WHERE tipo-rec-desp.tp-codigo = ordem-compra.tp-despesa NO-ERROR.
        
        RUN pi-busca-criticidade.


        CREATE Ordem_R1.
        ASSIGN Ordem_R1.NumeroPedidoCompra         = pedido-compr.num-pedido     
               Ordem_R1.NumeroOrdemCompra          = ordem-compra.numero-ordem    
               Ordem_R1.CodigoProduto              = ordem-compra.it-codigo   
               Ordem_R1.PartNumberItemFabricante   = IF AVAIL item-fabric THEN  item-fabric.it-fabric  ELSE ?
               Ordem_R1.CodigoUnidadeNegocio       = ordem-compra.cod-unid-negoc 
               Ordem_R1.NomeUnidadeNegocio         = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE ""
               Ordem_R1.NecessitaInspecaoOrigem    = IF AVAIL int-item-fornec-estab THEN int-item-fornec-estab.log-nec-inspec ELSE NO 
               Ordem_R1.ValorUnitarioItem          = ordem-compra.preco-fornec  
               Ordem_R1.ValorUnitarioIPI           = IF AVAIL cotacao-item THEN cotacao-item.pre-unit-for ELSE ?
               Ordem_R1.QuantidadeTotalOrdem       = ordem-compra.qt-solic 
               Ordem_R1.QuantidadeRecebidaOrdem    = ordem-compra.qt-acum-rec 
               Ordem_R1.CodigoDepositoOrdem        = ordem-compra.dep-almoxar 
               Ordem_R1.NomeDepositoOrdem          = IF AVAIL deposito THEN deposito.nome ELSE ""
               Ordem_R1.Destaque                   = IF AVAIL int-cotacao-item THEN int-cotacao-item.destaque ELSE ?
               Ordem_R1.NivelCriticidade           = IF AVAIL int-criticidade-item THEN int-criticidade-item.nivel-criticidade ELSE ? 
               Ordem_R1.CodigoMoedaEMS             = moeda.mo-codigo
               Ordem_R1.SituacaoOrdemCompra        = ordem-compra.situacao
               Ordem_R1.MatriculaComprador         = ordem-compra.cod-comprado
               Ordem_R1.NomeComprador              = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ?
               Ordem_R1.NumeroOrdemServico         = ordem-compra.ordem-servic
               Ordem_R1.MatriculaRequisitante      = ordem-compra.requisitante
               Ordem_R1.NomeRequisitante           = IF AVAIL b_usuar_mestre THEN b_usuar_mestre.nom_usuario ELSE ?
               Ordem_R1.CodigoContaContabil        = ordem-compra.ct-codigo
               Ordem_R1.CodigoCentroCusto          = ordem-compra.sc-codigo
               Ordem_R1.CodigoTipoDespesa          = ordem-compra.tp-despesa
               Ordem_R1.DescricaoTipoDespesa       = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ""
               Ordem_R1.NarrativaOrdemCompra       = ordem-compra.narrativa
               Ordem_R1.ObservacaoLogistica        = IF AVAIL int-item-uni-estab THEN int-item-uni-estab.observacao ELSE "". 

        IF msg0208.I18N AND ITEM.desc-inter <> "" THEN
            ASSIGN Ordem_R1.NomeProduto = IF AVAIL ITEM THEN ITEM.desc-inter ELSE ?.
        ELSE
            ASSIGN Ordem_R1.NomeProduto = IF ordem-compra.narrativa = "" THEN (IF AVAIL ITEM THEN ITEM.desc-item ELSE ?) ELSE STRING(ordem-compra.narrativa,"X(60)").
    END.

    RETURN "OK".
    
END PROCEDURE.

PROCEDURE pi-cria-cotacao:

    IF NOT CAN-FIND (FIRST Cotacao_R1
                     WHERE Cotacao_R1.NumeroOrdemCompra = ordem-compra.numero-ordem) THEN DO:

        FIND FIRST cotacao-item NO-LOCK
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.
    
        FIND FIRST int-cotacao-item NO-LOCK
             WHERE int-cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND int-cotacao-item.cod-emitente = pedido-compr.cod-emitente
               AND int-cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.
    
        CREATE Cotacao_R1.
        ASSIGN Cotacao_R1.NumeroOrdemCompra             = ordem-compra.numero-ordem 
               Cotacao_R1.CodigoUnidadeMedidaFornecedor = cotacao-item.un            
               Cotacao_R1.Reajuste                      = cotacao-item.reaj-tabela   
               Cotacao_R1.PrecoFornecedor               = cotacao-item.preco-fornec  
               Cotacao_R1.CodigoMoedaEMS                = cotacao-item.mo-codigo     
               Cotacao_R1.NumeroCotacao                 = cotacao-item.seq-cotac     
               Cotacao_R1.IPIIncluso                    = cotacao-item.codigo-ipi
               Cotacao_R1.AliquotaIPI                   = cotacao-item.aliquota-ipi 
               Cotacao_R1.TipoIcms                      = cotacao-item.codigo-icm
               Cotacao_R1.AliquotaIcms                  = cotacao-item.aliquota-icm
               Cotacao_R1.AliquotaIss                   = cotacao-item.aliquota-iss
               Cotacao_R1.NomeContato                   = cotacao-item.contato
               Cotacao_R1.FreteIncluso                  = cotacao-item.frete
               Cotacao_R1.ValorFrete                    = cotacao-item.valor-frete
               Cotacao_R1.TaxaFinanceira                = cotacao-item.valor-taxa
               Cotacao_R1.EncargosFinanceiros           = cotacao-item.taxa-financ
               Cotacao_R1.DiasTaxaFinanceira            = cotacao-item.nr-dias-taxa
               Cotacao_R1.PercentualDesconto            = cotacao-item.perc-descto
               Cotacao_R1.ValorDesconto                 = cotacao-item.valor-descto
               Cotacao_R1.PrazoEntrega                  = cotacao-item.prazo-entreg
               Cotacao_R1.PrecoUnitarioFornecedor       = cotacao-item.pre-unit-for.
    END.

    FIND FIRST cotacao-item NO-LOCK
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
           AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
           AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.

    IF NOT CAN-FIND (FIRST CotacaoItemImportado_R1
                     WHERE CotacaoItemImportado_R1.NumeroOrdemCompra = ordem-compra.numero-ordem 
                       AND CotacaoItemImportado_R1.SequenciaCotacao  = cotacao-item.seq-cotac) THEN DO:
    
        IF emitente.natureza = 3 /*Estrangeiro*/ THEN DO:
            RELEASE mgesp.fabricante.

            FIND FIRST item-fornec-estab NO-LOCK
                 WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo 
                   AND item-fornec-estab.cod-emitente = pedido-compr.cod-emitente
                   AND item-fornec-estab.cod-estabel  = pedido-compr.cod-estabel NO-ERROR.
            IF AVAIL item-fornec-estab THEN DO:
               FIND FIRST b5-emitente NO-LOCK
                    WHERE b5-emitente.cod-emitente = int(item-fornec-estab.item-do-forn) NO-ERROR.
               IF AVAIL b5-emitente THEN
                  find mgesp.fabricante 
                        where fabricante.cod-fabric = b5-emitente.cod-emitente NO-LOCK NO-ERROR.
            END.
            ELSE DO:
               FIND FIRST b5-emitente NO-LOCK
                    WHERE b5-emitente.cod-emitente = int(SUBSTRING(cotacao-item.char-2,41,9)) NO-ERROR.
            END.
               

            FIND FIRST pto-contr NO-LOCK
                 WHERE pto-contr.cod-pto-contr = /*cotacao-item.cod-pto-contr*/ int(SUBSTRING(cotacao-item.char-1,41,5)) NO-ERROR.

            FIND FIRST itinerario NO-LOCK
                 WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.
        
            FIND FIRST mgcad.pais NO-LOCK
                 WHERE mgcad.pais.cod-pais = cotacao-item.cdn-pais-orig NO-ERROR.

            ASSIGN c-ex-tarifario = "".
            IF  AVAIL int-cotacao-item THEN DO:
                ASSIGN c-ex-tarifario = int-cotacao-item.ex-tarifario.
            END.
            ELSE DO:
                FIND FIRST item
                    WHERE item.it-codigo = cotacao-item.it-codigo NO-LOCK NO-ERROR.
                IF  AVAILABLE item THEN DO:
                    FIND FIRST int-item
                        WHERE int-item.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
                    IF  AVAILABLE int-item THEN DO:
                        ASSIGN c-ex-tarifario = int-item.ex-tarifario.
                    END.
                END.
            END.

            CREATE CotacaoItemImportado_R1.
            ASSIGN CotacaoItemImportado_R1.NumeroOrdemCompra          = ordem-compra.numero-ordem 
                   CotacaoItemImportado_R1.SequenciaCotacao           = cotacao-item.seq-cotac
                   CotacaoItemImportado_R1.CotacaoAprovada            = cotacao-item.cot-aprovada
                   CotacaoItemImportado_R1.MapaCotacao                = cotacao-item.mapa-cotacao
                   CotacaoItemImportado_R1.CodigoIncoterm             = SUBSTRING(cotacao-item.char-1,21,3)          
                   CotacaoItemImportado_R1.CodigoPontoControleBase    = /*cotacao-item.cod-pto-contr*/ int(SUBSTRING(cotacao-item.char-1,41,5))
                   CotacaoItemImportado_R1.DescricaoPontoControleBase = IF AVAIL pto-contr   THEN pto-contr.descricao      ELSE ""
                   CotacaoItemImportado_R1.CodigoFabricante           = IF AVAIL b5-emitente THEN b5-emitente.cod-emitente ELSE ?
                   CotacaoItemImportado_R1.NomeFabricante             = IF AVAIL fabricante THEN fabricante.nome-abrev ELSE IF AVAIL b5-emitente THEN b5-emitente.nome-abrev ELSE ""
                   CotacaoItemImportado_R1.NCM                        = trim(SUBSTRING(cotacao-item.char-1, 81, 10))
                   CotacaoItemImportado_R1.DestaqueNCM                = IF AVAIL int-cotacao-item THEN int-cotacao-item.destaque ELSE 0
                   CotacaoItemImportado_R1.PaisOrigem                 = IF AVAIL mgcad.pais THEN pais.nome-pais ELSE ""
                   CotacaoItemImportado_R1.AliquotaII                 = /*cotacao-item.aliquota-ii*/ DEC(SUBSTRING(cotacao-item.char-1,61,6))
                   CotacaoItemImportado_R1.CodigoItinerario           = cotacao-item.int-1
                   CotacaoItemImportado_R1.DescricaoItinerario        = IF AVAIL itinerario THEN itinerario.descricao ELSE ""
                   CotacaoItemImportado_R1.NVE                        = IF AVAIL int-cotacao-item THEN int-cotacao-item.nve ELSE ?
                   CotacaoItemImportado_R1.ExTarifario                = c-ex-tarifario
                   CotacaoItemImportado_R1.NecessitaLicencaImportacao = item.log-necessita-li                
                   CotacaoItemImportado_R1.GATT                       = IF AVAIL int-cotacao-item THEN int-cotacao-item.log-gatt  ELSE ?
                   CotacaoItemImportado_R1.PercentualGATT             = IF AVAIL int-cotacao-item THEN int-cotacao-item.perc-gatt ELSE ?.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-cria-parcela:
    IF NOT CAN-FIND (FIRST Parcela_R1
                     WHERE Parcela_R1.NumeroOrdem = prazo-compra.numero-ordem
                       AND Parcela_R1.Sequencia   = prazo-compra.parcela) THEN DO:

        FIND FIRST int-prazo-compra OF prazo-compra NO-LOCK NO-ERROR.

        DEFINE VARIABLE i-dias-atraso AS INTEGER     NO-UNDO.
        FIND FIRST cotacao-item NO-LOCK
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.

        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo 
               AND item-fornec-estab.cod-emitente = pedido-compr.cod-emitente
               AND item-fornec-estab.cod-estabel  = pedido-compr.cod-estabel NO-ERROR.

        FIND FIRST itinerario NO-LOCK
             WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.

        FIND FIRST pto-contr NO-LOCK
             WHERE pto-contr.cod-pto-contr = itinerario.pto-embarque NO-ERROR.

        FIND LAST b-ordens-embarque NO-LOCK
            WHERE b-ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
              AND b-ordens-embarque.parcela      = prazo-compra.parcela NO-ERROR.

        RELEASE embarque-imp.
        RELEASE b-historico-embarque.

        IF AVAIL b-ordens-embarque THEN DO:
            FIND FIRST embarque-imp NO-LOCK
                 WHERE embarque-imp.cod-estabel = b-ordens-embarque.cod-estabel
                   AND embarque-imp.embarque    = b-ordens-embarque.embarque NO-ERROR.

            FIND FIRST b-historico-embarque NO-LOCK
                 WHERE b-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch
                   AND b-historico-embarque.cod-estabel   = b-ordens-embarque.cod-estabel
                   AND b-historico-embarque.embarque      = b-ordens-embarque.embarque NO-ERROR.
                  
        END.
        ELSE DO:
            ASSIGN i-dias-atraso = TODAY - prazo-compra.data-entrega.
        END.

        FIND LAST historico-inspecao NO-LOCK
            WHERE historico-inspecao.numero-ordem = prazo-compra.numero-ordem
              AND historico-inspecao.parcela      = prazo-compra.parcela NO-ERROR.

        FIND FIRST licenciam-import-oc NO-LOCK
             WHERE licenciam-import-oc.numero-ordem = prazo-compra.numero-ordem 
               AND licenciam-import-oc.parcela      = prazo-compra.parcela NO-ERROR.

        FIND FIRST int-licenciam-import-oc EXCLUSIVE-LOCK
                 WHERE int-licenciam-import-oc.numero-ordem = licenciam-import-oc.numero-ordem
                   AND int-licenciam-import-oc.parcela      = licenciam-import-oc.parcela NO-ERROR.

        FIND LAST recebimento NO-LOCK
            WHERE recebimento.numero-ordem = prazo-compra.numero-ordem
              AND recebimento.parcela      = prazo-compra.parcela NO-ERROR.

        RUN pi-busca-data-embarque.

        RUN calcula-indice (INPUT  prazo-compra.numero-ordem,
                            INPUT  prazo-compra.parcela,     
                            INPUT  ordem-compra.it-codigo,   
                            INPUT  ordem-compra.cod-emitente,
                            OUTPUT de-indice).

        ASSIGN i-id-relac = i-id-relac + 1.
        CREATE Parcela_R1.
        ASSIGN Parcela_R1.id-relac                      = i-id-relac
               Parcela_R1.NumeroOrdem                   = prazo-compra.numero-ordem    
               Parcela_R1.SequenciaParcela              = prazo-compra.parcela
               Parcela_R1.DataOriginalParcela           = prazo-compra.data-orig      
               Parcela_R1.DataParcela                   = prazo-compra.data-entrega 
               Parcela_R1.QuantidadeParcela             = prazo-compra.quantidade 
               Parcela_R1.CodigoUnidadeMedida           = prazo-compra.un
               Parcela_R1.QuantidadeFornecedor          = prazo-compra.qtd-do-forn      
               /*Parcela_R1.CodigoUnidadeMedidaFornecedor = IF AVAIL item-fornec-estab THEN item-fornec-estab.unid-med-for ELSE ?*/
               Parcela_R1.SituacaoMovimentoParcela      = 1      /* NOVOS CAMPOS - DEPENDEM DA MSG DE INSPECAO */
               Parcela_R1.ValorParcela                  = ordem-compra.preco-fornec * prazo-compra.qtd-do-forn
               Parcela_R1.ValorParcelaIPI               = IF AVAIL cotacao-item         THEN cotacao-item.pre-unit-for * prazo-compra.qtd-do-forn ELSE ?
               Parcela_R1.DiasAtraso                    = i-dias-atraso                 
               Parcela_R1.NumeroEmbarque                = IF AVAIL embarque-imp            THEN embarque-imp.embarque               ELSE ?
               Parcela_R1.EmbarqueContabilizado         = IF AVAIL embarque-imp            THEN embarque-imp.Contabilizado          ELSE ?
               Parcela_R1.House                         = IF AVAIL embarque-imp            THEN embarque-imp.cod-conhecto-house     ELSE ?
               Parcela_R1.Master                        = IF AVAIL embarque-imp            THEN embarque-imp.cod-conhecto-master    ELSE ?
               Parcela_R1.PesoBruto                     = IF AVAIL b-ordens-embarque       THEN b-ordens-embarque.peso-bruto        ELSE ?
               Parcela_R1.PesoLiquido                   = IF AVAIL b-ordens-embarque       THEN b-ordens-embarque.peso-liquido      ELSE ? 
               Parcela_R1.Cubagem                       = IF AVAIL b-ordens-embarque       THEN b-ordens-embarque.val-cub-tot       ELSE ?
               Parcela_R1.DataDespacho                  = IF AVAIL b-historico-embarque THEN 
                                                                     IF b-historico-embarque.dt-efetiva <> ? THEN 
                                                                        b-historico-embarque.dt-efetiva
                                                                     ELSE b-historico-embarque.dt-ult-previsao
                                                                 ELSE ?
               Parcela_R1.NumeroLIAnuida                = IF AVAIL licenciam-import-oc     THEN licenciam-import-oc.licenca-import  ELSE ?
               Parcela_R1.ValidadeLI                    = IF AVAIL int-licenciam-import-oc THEN int-licenciam-import-oc.validade-li ELSE ?
               Parcela_R1.LocalEmbarqueParcela          = IF AVAIL pto-contr               THEN pto-contr.descricao                 ELSE ?
               Parcela_R1.SituacaoParcela               = prazo-compra.situacao
               Parcela_R1.NumeroNotaFiscal              = IF AVAIL recebimento THEN recebimento.numero-nota ELSE ?                    
               Parcela_R1.NumeroSerie                   = IF AVAIL recebimento THEN recebimento.serie-nota  ELSE ?   
               Parcela_R1.MatriculaUsuarioRecebimento   = IF AVAIL recebimento THEN recebimento.usuario     ELSE ?
               Parcela_R1.QuantidadeSaldo               = prazo-compra.quant-saldo * de-indice
               Parcela_R1.NumeroNotaFiscalPrevista      = IF AVAIL int-prazo-compra THEN int-prazo-compra.nro-docto   ELSE ""
               Parcela_R1.SerieNotaFiscalPrevista       = IF AVAIL int-prazo-compra THEN int-prazo-compra.serie-docto ELSE "".

               ASSIGN Parcela_R1.DataNecessidade = IF AVAIL int-prazo-compra THEN int-prazo-compra.data-necessidade ELSE ?.

               IF AVAIL embarque-imp THEN DO:
                  run calcularDiasAcompanhamentoHistEmb in h-bocx230 (input embarque-imp.cod-estabel,
                                                                      input embarque-imp.embarque,  
                                                                      output i-dias-total,
                                                                      output table tt-bo-erro).
                  ASSIGN Parcela_R1.DataEntregaIdeal = IF AVAIL int-prazo-compra THEN int-prazo-compra.data-necessidade - i-dias-total ELSE ?.
               
               END.

               IF AVAIL embarque-imp THEN DO:           
                   RUN pi-situacao.                     
                   ASSIGN Parcela_R1.SituacaoEmbarque   = IF AVAIL tt-emb     THEN tt-emb.situacao      ELSE 1.
               END.                                     
               ELSE DO:                                 
                   ASSIGN Parcela_R1.SituacaoEmbarque   = 1.
               END.

        IF Ordem_R1.NecessitaInspecaoOrigem THEN DO:
          /*  ASSIGN Parcela_R1.DataLimiteInspecao = IF AVAIL b-historico-embarque THEN 
                                                       IF b-historico-embarque.dt-efetiva <> ? THEN 
                                                           b-historico-embarque.dt-efetiva - 10 
                                                       ELSE b-historico-embarque.dt-ult-previsao - 10 
                                                   ELSE ?. 
          *******comentado conforme chamado 121600 */
          ASSIGN Parcela_R1.DataLimiteInspecao =  IF AVAIL b3-historico-embarque 
                                                  AND b3-historico-embarque.dt-efetiva <> ? THEN 
                                                      b3-historico-embarque.dt-efetiva 
                                                  ELSE IF AVAIL b3-historico-embarque THEN
                                                      b3-historico-embarque.dt-ult-prev
                                                  ELSE 
                                                     IF AVAIL b-historico-embarque THEN 
                                                        IF b-historico-embarque.dt-efetiva <> ? THEN 
                                                            b-historico-embarque.dt-efetiva - 10 
                                                        ELSE b-historico-embarque.dt-ult-previsao - 10 
                                                     ELSE ?. 

        END.

        /* montar lista de retorno com as inspees*/
        
        FOR EACH historico-inspecao NO-LOCK
            WHERE historico-inspecao.numero-ordem = prazo-compra.numero-ordem
              AND historico-inspecao.parcela      = prazo-compra.parcela
              BREAK BY historico-inspecao.CodigoAgendamento
                    BY historico-inspecao.sequencia:

            LOG-MANAGER:WRITE-MESSAGE(" LAST-OF(historico-inspecao.CodigoAgendamento): " + STRING( LAST-OF(historico-inspecao.CodigoAgendamento))).
            LOG-MANAGER:WRITE-MESSAGE(" historico-inspecao.RegistroRemovido: " + STRING(historico-inspecao.RegistroRemovido)).
              IF  LAST-OF(historico-inspecao.CodigoAgendamento) AND NOT historico-inspecao.RegistroRemovido THEN DO:
                  CREATE InspecaoAgendada.
                  ASSIGN InspecaoAgendada.id-relac                = i-id-relac
                         InspecaoAgendada.CodigoAgendamento       = historico-inspecao.CodigoAgendamento
                         InspecaoAgendada.DataAgendamentoInspecao = historico-inspecao.data-prev-inspe    
                         InspecaoAgendada.DuracaoAgendamento      = historico-inspecao.duracao-agendamento 
                         InspecaoAgendada.DataExecucaoInspecao    = historico-inspecao.data-inspec        
                         InspecaoAgendada.DuracaoExecucao         = historico-inspecao.duracao-execucao
                         InspecaoAgendada.StatusInspecao          = historico-inspecao.status-inspec         
                         InspecaoAgendada.ObservacoesInspecao     = historico-inspecao.obs-inspec      
                         InspecaoAgendada.QuantidadeAgendada      = historico-inspecao.qtd-agendada      
                         InspecaoAgendada.QuantidadeInspecionada  = historico-inspecao.qtd-inspecionada      
                         InspecaoAgendada.CodigoInspetor          = historico-inspecao.cod-inspetor 
                         InspecaoAgendada.NomeInspetor            = historico-inspecao.nome-inspetor
                         InspecaoAgendada.RegiaoInspecao          = historico-inspecao.regiao-inspec.
              END.
        END.

    END.

    RETURN "OK".

END PROCEDURE.


PROCEDURE pi-busca-criticidade:
           
    DEFINE VARIABLE i-cd-plano AS INTEGER   NO-UNDO.

    CASE pedido-compr.cod-estabel:
        WHEN "101" THEN
            ASSIGN i-cd-plano = 1.
        WHEN "104" THEN DO:
            IF ITEM.it-codigo >= "4000000" 
                AND ITEM.it-codigo <= "4999999" THEN
                ASSIGN i-cd-plano = 4.
            ELSE
                ASSIGN i-cd-plano = 41.
        END.
        WHEN "105" THEN
            ASSIGN i-cd-plano = 5.
        WHEN "106" THEN
            ASSIGN i-cd-plano = 6.
        WHEN "107" THEN
            ASSIGN i-cd-plano = 7.
    END CASE.

    IF AVAIL ITEM THEN
        FIND LAST int-criticidade-item NO-LOCK 
            WHERE int-criticidade-item.cod-estabel = pedido-compr.cod-estabel
              AND int-criticidade-item.cd-plano    = i-cd-plano
              AND int-criticidade-item.it-codigo   = ITEM.it-codigo NO-ERROR.
            
END PROCEDURE.       


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.
PROCEDURE pi-situacao :

    {esp/imp/esimp000.i}
    
END PROCEDURE.

PROCEDURE calcula-indice:
    DEFINE INPUT  PARAM p-numero-ordem LIKE ordem-compra.numero-ordem.
    DEFINE INPUT  PARAM p-parcela      LIKE prazo-compra.parcela.
    DEFINE INPUT  PARAM p-it-codigo    LIKE ITEM.it-codigo.
    DEFINE INPUT  PARAM p-cod-emitente LIKE ordem-compra.cod-emitente.
    DEFINE OUTPUT PARAM p-indice       AS DEC.

    DEFINE BUFFER b-prazo-compra FOR prazo-compra.

    FIND FIRST b-prazo-compra NO-LOCK USE-INDEX ordem
         WHERE b-prazo-compra.numero-ordem = p-numero-ordem
           AND b-prazo-compra.parcela      = p-parcela NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    ASSIGN p-indice = 1.

    IF AVAILABLE ITEM THEN DO:
        FIND FIRST item-fornec NO-LOCK
             WHERE item-fornec.it-codigo    = ITEM.it-codigo
               AND item-fornec.cod-emitente = p-cod-emitente NO-ERROR.

        IF  (ITEM.tipo-contr = 4 
        AND NOT AVAILABLE item-fornec 
        OR  ITEM.it-codigo = "":U) THEN DO:

            IF  AVAILABLE cotacao-item            
            AND cotacao-item.un <> b-prazo-compra.un THEN DO:

                FIND FIRST tab-conv-un NO-LOCK
                     WHERE tab-conv-un.un           = b-prazo-compra.un
                       AND tab-conv-un.unid-med-for = cotacao-item.un NO-ERROR.

                IF AVAILABLE tab-conv-un THEN
                    ASSIGN p-indice = tab-conv-un.fator-conver / EXP(10, tab-conv-un.num-casa-dec).
            END.
        END.
        ELSE IF AVAILABLE item-fornec THEN
            ASSIGN p-indice = item-fornec.fator-conver / EXP(10, item-fornec.num-casa-dec).
    END.
END PROCEDURE.

PROCEDURE pi-busca-data-embarque:

    FIND FIRST b3-historico-embarque NO-LOCK  
         WHERE b3-historico-embarque.cod-estabel = pedido-compr.cod-estabel 
           AND b3-historico-embarque.embarque    = b-ordens-embarque.embarque NO-ERROR.

    FIND FIRST itinerario NO-LOCK
         WHERE itinerario.cod-itiner = b3-historico-embarque.cod-itiner NO-ERROR.

    FIND FIRST b3-historico-embarque NO-LOCK
         WHERE b3-historico-embarque.cod-estabel   = pedido-compr.cod-estabel 
           AND b3-historico-embarque.embarque      = b-ordens-embarque.embarque
           AND b3-historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.
            
    RETURN "OK".
END PROCEDURE.

