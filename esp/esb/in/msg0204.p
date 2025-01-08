CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>1760003-104-4</NumeroOperacao>                              */
/*     <CodigoMensagem>MSG0204</CodigoMensagem>                                    */
/*     <LoginUsuario>an052591</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0204>                                                                   */
/*       <CodigoEstabelecimento>104</CodigoEstabelecimento>                        */
/*       <CodigoPlano>4</CodigoPlano>                                              */
/*       <ItensSimulacao>                                                          */
/*         <CodigoProduto>1760003</CodigoProduto>                                  */
/*       </ItensSimulacao>                                                         */
/*       <ConsideraOrdensCompra>true</ConsideraOrdensCompra>                       */
/*       <ConsideraOrdensProducao>true</ConsideraOrdensProducao>                   */
/*       <ConsideraOrdensPlanejadas>true</ConsideraOrdensPlanejadas>               */
/*       <ConsideraReservasComprometidas>true</ConsideraReservasComprometidas>     */
/*       <ConsideraReservasPlanejadas>true</ConsideraReservasPlanejadas>           */
/*       <ConsideraSaldoEstoque>true</ConsideraSaldoEstoque>                       */
/*       <ConsideraSaldoTerceiros>true</ConsideraSaldoTerceiros>                   */
/*       <ConsideraPedidosCarteira>true</ConsideraPedidosCarteira>                 */
/*       <ApenasPedidosCreditoAprovado>true</ApenasPedidosCreditoAprovado>         */
/*       <OrdensCompraBeneficiamento>2</OrdensCompraBeneficiamento>                */
/*       <ConsideraRemessaBeneficiamento>true</ConsideraRemessaBeneficiamento>     */
/*       <ConsideraEntradaBeneficiamento>true</ConsideraEntradaBeneficiamento>     */
/*       <ConsideraTransferencia>true</ConsideraTransferencia>                     */
/*       <ConsideraRemessaConsignacao>true</ConsideraRemessaConsignacao>           */
/*       <ConsideraEntradaConsignacao>true</ConsideraEntradaConsignacao>           */
/*       <SomenteOEM>true</SomenteOEM>                                             */
/*       <I18N>false</I18N>                                                        */
/*     </MSG0204>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0204.i}

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0204, ItensSimulacao
   DATA-RELATION FOR conteudo, msg0204        RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0204, ItensSimulacao  RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0204R1, ItemEstoque, RegistroEstoque, resultado 
   DATA-RELATION FOR conteudor, msg0204R1         RELATION-FIELDS (idm, idm)                     NESTED
   DATA-RELATION FOR msg0204R1, ItemEstoque       RELATION-FIELDS (idm, idm)                     NESTED
   DATA-RELATION FOR ItemEstoque, RegistroEstoque RELATION-FIELDS (CodigoProduto, CodigoProduto) NESTED
   DATA-RELATION FOR msg0204R1, resultado         RELATION-FIELDS (idm, idm)                     NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0204R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0204 NO-ERROR.

CREATE conteudor.
CREATE msg0204R1.
CREATE resultado.


FOR EACH ItensSimulacao NO-LOCK
    BREAK BY ItensSimulacao.CodigoProduto:

    /*No caso de receber mais de uma vez o mesmo item realiza a simula‡Æo somente para o primeiro*/
    IF FIRST-OF (ItensSimulacao.CodigoProduto) THEN DO:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = ItensSimulacao.CodigoProduto NO-ERROR.
    
        ASSIGN gr-item = ROWID(item).
    
        RUN pi-calc-sim-estoque (INPUT ROWID (ITEM),
                                 OUTPUT de-saldo-inic,
                                 OUTPUT de-saldo-inic-teor,
                                 OUTPUT de-quant-segur,
                                 OUTPUT de-saldo-terc,
                                 OUTPUT de-saldo-terc-teor).
    
        RUN pi-calcula-fat-pendente.
    END.

END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

PROCEDURE pi-calc-sim-estoque :
    
    DEF INPUT  PARAMETER r-item               AS ROWID   NO-UNDO.
    DEF OUTPUT PARAMETER p-de-saldo-inic      AS DECIMAL NO-UNDO.
    DEF OUTPUT PARAMETER p-de-saldo-inic-teor AS DECIMAL NO-UNDO.
    DEF OUTPUT PARAMETER p-de-quant-segur     AS DECIMAL NO-UNDO.
    DEF OUTPUT PARAMETER p-de-saldo-terc      AS DECIMAL NO-UNDO.

    DEF OUTPUT PARAMETER p-de-saldo-terc-teor AS DECIMAL NO-UNDO.
    
    DEF VAR i-nr-linha-ini AS INT NO-UNDO.
    DEF VAR i-nr-linha-fim AS INT NO-UNDO.
    DEF VAR c-plan-ini     LIKE ITEM.cd-planejado NO-UNDO.
    DEF VAR c-plan-fim     LIKE ITEM.cd-planejado NO-UNDO.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    FIND FIRST ITEM NO-LOCK
         WHERE ROWID(ITEM) = r-item NO-ERROR.
    
    FIND FIRST b-item NO-LOCK
        WHERE ROWID(b-item) = r-item NO-ERROR.
    
    ASSIGN c-cod-refer  = ITEM.cod-refer
           l-apenas-oem = msg0204.SomenteOEM
           da-dt-corte  = 12/31/9999
           l-ord-comp   = msg0204.ConsideraOrdensCompra
           l-res-comp   = msg0204.ConsideraReservasComprometidas
           l-pedidos    = msg0204.ConsideraPedidosCarteira
           da-dt-plan   = 12/31/9999.

    RUN esp/es0018p.p (INPUT "msg0204":U, 
                       INPUT 1, 
                       INPUT 0, 
                       INPUT "":U, 
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto 
         WHERE entry(1,tt-prog-ponto.conteudo,";") = msg0204.CodigoEstabelecimento
           AND entry(2,tt-prog-ponto.conteudo,";") = string(msg0204.CodigoPlano) NO-ERROR.
    IF AVAIL tt-prog-ponto THEN
       RUN pi-simulacao-estoque(BUFFER b-item,
                                INPUT msg0204.ConsideraSaldoEstoque,
                                INPUT msg0204.ConsideraRemessaBeneficiamento,
                                INPUT msg0204.ConsideraEntradaBeneficiamento,
                                INPUT msg0204.ConsideraTransferencia,
                                INPUT msg0204.ConsideraRemessaConsignacao,
                                INPUT msg0204.ConsideraEntradaConsignacao,
                                INPUT "", /**/
                                INPUT "", /**/
                                INPUT 0,  /**/
                                INPUT 0,  /**/
                                INPUT msg0204.ConsideraSaldoTerceiros,
                                INPUT msg0204.CodigoEstabelecimento,        /* Estab Inicial*/
                                INPUT entry(3,tt-prog-ponto.conteudo,";"),  /* Estab Final*/
                                INPUT msg0204.ConsideraOrdensProducao,
                                INPUT msg0204.OrdensCompraBeneficiamento,
                                INPUT msg0204.ApenasPedidosCreditoAprovado,
                                INPUT msg0204.ConsideraOrdensPlanejadas,
                                INPUT msg0204.ConsideraReservasPlanejadas,
                                INPUT msg0204.CodigoPlano,
                                INPUT "",   /*Unidade de Neg¢cio Inicial*/
                                INPUT "zzz" /*Unidade de Neg¢cio Final*/ ).
    ELSE
       RUN pi-simulacao-estoque(BUFFER b-item,
                                INPUT msg0204.ConsideraSaldoEstoque,
                                INPUT msg0204.ConsideraRemessaBeneficiamento,
                                INPUT msg0204.ConsideraEntradaBeneficiamento,
                                INPUT msg0204.ConsideraTransferencia,
                                INPUT msg0204.ConsideraRemessaConsignacao,
                                INPUT msg0204.ConsideraEntradaConsignacao,
                                INPUT "", /**/
                                INPUT "", /**/
                                INPUT 0,  /**/
                                INPUT 0,  /**/
                                INPUT msg0204.ConsideraSaldoTerceiros,
                                INPUT msg0204.CodigoEstabelecimento,
                                INPUT msg0204.CodigoEstabelecimento,
                                INPUT msg0204.ConsideraOrdensProducao,
                                INPUT msg0204.OrdensCompraBeneficiamento,
                                INPUT msg0204.ApenasPedidosCreditoAprovado,
                                INPUT msg0204.ConsideraOrdensPlanejadas,
                                INPUT msg0204.ConsideraReservasPlanejadas,
                                INPUT msg0204.CodigoPlano,
                                INPUT "",   /*Unidade de Neg¢cio Inicial*/
                                INPUT "zzz" /*Unidade de Neg¢cio Final*/ ).


    IF  param-global.modulo-per-ppm 
    AND AVAIL ITEM AND ITEM.tipo-formula >= 2 
    AND ITEM.tipo-formula <= 3 THEN
        ASSIGN de-saldo = de-saldo-inic-teor.
    ELSE
        ASSIGN de-saldo = de-saldo-inic.
    
    FOR EACH tt-estoq
        BY tt-estoq.dt-termino:

        IF tt-estoq.tipo = c-liter[5] 
        OR tt-estoq.tipo = c-liter[6] 
        OR tt-estoq.tipo = c-liter[8] THEN DO:
            ASSIGN de-saldo      = de-saldo - tt-estoq.quantidade
                   de-quantidade = (tt-estoq.quantidade * (-1)).
        END.
        ELSE
            ASSIGN de-saldo = de-saldo + IF tt-estoq.tipo = c-liter[2] THEN 0 ELSE tt-estoq.quantidade
                   de-quantidade = tt-estoq.quantidade.
    
        ASSIGN tt-estoq.obs        = IF de-saldo < 0 THEN c-liter[9] ELSE IF de-saldo < de-quant-segur THEN c-liter[10] ELSE ""
               tt-estoq.saldo      = de-saldo
               tt-estoq.quantidade = de-quantidade.

        RUN pi-gera-retorno.
    END.
    
    ASSIGN p-de-saldo-inic      = de-saldo-inic
           p-de-saldo-inic-teor = de-saldo-inic-teor
           p-de-quant-segur     = de-quant-segur
           p-de-saldo-terc      = de-saldo-terc
           p-de-saldo-terc-teor = de-saldo-terc-teor.

END PROCEDURE.

PROCEDURE pi-calcula-fat-pendente:

FOR EACH res-item NO-LOCK
   WHERE res-item.it-codigo   = ITEM.it-codigo
     AND res-item.cod-refer   = ITEM.cod-refer
     AND res-item.cod-estabel >= msg0204.CodigoEstabelecimento 
     AND res-item.cod-estabel <= msg0204.CodigoEstabelecimento:

    ASSIGN de-saldo-fat = de-saldo-fat + res-item.dec-1.

END.
END PROCEDURE.

PROCEDURE pi-gera-retorno:
    RELEASE ordem-compra.
    RELEASE prazo-compra.
    RELEASE int-prazo-compra.
    
    IF tt-estoq.tipo MATCHES "*O C*" THEN DO:
        FIND FIRST ordem-compra NO-LOCK
             WHERE ordem-compra.numero-ordem = INT(REPLACE(ENTRY(1,tt-estoq.referencia,"/"),".","") ) NO-ERROR.
    
        FIND FIRST prazo-compra NO-LOCK
             WHERE prazo-compra.numero-ordem = INT(REPLACE(ENTRY(1,tt-estoq.referencia,"/"),".","") )
               AND prazo-compra.parcela      = INT(ENTRY(2,tt-estoq.referencia,"/"))  NO-ERROR.

        FIND FIRST int-prazo-compra NO-LOCK
             WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
               AND int-prazo-compra.parcela      = prazo-compra.parcela NO-ERROR.  
    END.

    FIND FIRST ordens-embarque NO-LOCK
         WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
           AND ordens-embarque.parcela      = prazo-compra.parcela NO-ERROR.

    FIND FIRST historico-embarque NO-LOCK  
         WHERE historico-embarque.cod-estabel = msg0204.CodigoEstabelecimento
           AND historico-embarque.embarque    = ordens-embarque.embarque NO-ERROR.

    FIND FIRST itinerario NO-LOCK
         WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

    /*
    FIND FIRST historico-embarque NO-LOCK
         WHERE historico-embarque.cod-estabel   = msg0204.CodigoEstabelecimento
           AND historico-embarque.embarque      = ordens-embarque.embarque
           AND historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.
    */
    FIND FIRST item-uni-estab NO-LOCK
         WHERE item-uni-estab.it-codigo   = ITEM.it-codigo
           AND item-uni-estab.cod-estabel = msg0204.CodigoEstabelecimento NO-ERROR.

    FIND FIRST int-item-uni-estab NO-LOCK
         WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
           AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-ERROR.

    FIND FIRST usuar_mestre NO-LOCK 
         WHERE usuar_mestre.cod_usuario = item-uni-estab.cod-comprado NO-ERROR.

    FIND FIRST tab-unidade NO-LOCK 
         WHERE tab-unidade.un = ITEM.un NO-ERROR.

    FIND FIRST int-analise-ordem-compra EXCLUSIVE-LOCK
         WHERE int-analise-ordem-compra.numero-ordem = prazo-compra.numero-ordem 
           AND int-analise-ordem-compra.parcela      = prazo-compra.parcela NO-ERROR.

    /*Quando a ordem ainda est  sem fornecedor considera o fornecedor da cota‡Æo*/
    RELEASE item-fornec-estab.
    RELEASE emitente.
    
    /* Busca item-fornec-estab para RegistroEstoque */
    IF tt-estoq.tipo MATCHES "*O C*" THEN DO:

        IF ordem-compra.cod-emitente <> 0 THEN DO:
            FIND FIRST item-fornec-estab NO-LOCK      
                 WHERE item-fornec-estab.it-codigo    = ITEM.it-codigo
                   AND item-fornec-estab.cod-estabel  = msg0204.CodigoEstabelecimento
                   AND item-fornec-estab.cod-emitente = ordem-compra.cod-emitente NO-ERROR.   

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
        END.
        ELSE DO:
            IF ordem-compra.situacao = 5 /*Em cota‡Æo*/ THEN DO:
                /*Considera fornecedor da primeira cota‡Æo parametrizado no cc0531 (data <> 11/11/1111)*/
                FIND FIRST cotacao-item NO-LOCK 
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                       AND cotacao-item.data-cotacao <> 11/11/1111 NO-ERROR.
            END.
            ELSE DO:
                FIND FIRST cotacao-item NO-LOCK 
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-ERROR.
            END.

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = cotacao-item.cod-emitente NO-ERROR.
    
            FIND FIRST item-fornec-estab NO-LOCK      
                 WHERE item-fornec-estab.it-codigo    = ITEM.it-codigo
                   AND item-fornec-estab.cod-estabel  = msg0204.CodigoEstabelecimento
                   AND item-fornec-estab.cod-emitente = emitente.cod-emitente NO-ERROR.   

            FIND FIRST int-item-fornec-estab NO-LOCK
                 WHERE int-item-fornec-estab.it-codigo    = ITEM.it-codigo 
                   AND int-item-fornec-estab.cod-emitente = emitente.cod-emitente
                   AND int-item-fornec-estab.cod-estabel  = msg0204.CodigoEstabelecimento NO-ERROR.
            
        END.
    END.
    
    RELEASE b-historico-embarque.

    /*Ultimo Ponto de controle efetivado*/
    FOR LAST b-historico-embarque NO-LOCK
       WHERE b-historico-embarque.cod-estabel = msg0204.CodigoEstabelecimento
         AND b-historico-embarque.embarque    = ordens-embarque.embarque
         AND b-historico-embarque.cod-itiner  = itinerario.cod-itiner
         AND b-historico-embarque.dt-efetiva <> ?
       BREAK BY b-historico-embarque.dt-efetiva:
    END.

    FIND FIRST pto-contr NO-LOCK
         WHERE pto-contr.cod-pto-contr = b-historico-embarque.cod-pto-contr NO-ERROR.

    RUN pi-busca-posicao.

    /* Buscar Data Embarque */
    FIND FIRST historico-embarque NO-LOCK
         WHERE historico-embarque.cod-estabel   = msg0204.CodigoEstabelecimento
           AND historico-embarque.embarque      = ordens-embarque.embarque
           AND historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.

    FIND FIRST tt-emb NO-ERROR.

    /* Obter Fornecedor padrao do item */
    ASSIGN i-cod-fornec  = 0
           i-perc-compra = 0.
    FOR EACH b-item-fornec-estab NO-LOCK      
         WHERE b-item-fornec-estab.it-codigo    = ITEM.it-codigo
           AND b-item-fornec-estab.cod-estabel  = msg0204.CodigoEstabelecimento
           AND b-item-fornec-estab.ativo        = YES:

        IF b-item-fornec-estab.perc-compra > i-perc-compra THEN
            ASSIGN i-cod-fornec  = b-item-fornec-estab.cod-emitente
                   i-perc-compra = b-item-fornec-estab.perc-compra.
    END.

    FIND FIRST b-item-fornec-estab NO-LOCK      
         WHERE b-item-fornec-estab.it-codigo    = ITEM.it-codigo
           AND b-item-fornec-estab.cod-estabel  = msg0204.CodigoEstabelecimento
           AND b-item-fornec-estab.cod-emitente = i-cod-fornec NO-ERROR.  

    RELEASE int-item-fornec-estab.
    RELEASE item-fornec-estab.
    RELEASE item-fabric.
    RELEASE int-item-for-PN.

    FIND FIRST int-item-for-PN NO-LOCK
         WHERE int-item-for-PN.cod-emitente = i-cod-fornec
           AND int-item-for-PN.it-codigo    = ITEM.it-codigo NO-ERROR.

    IF AVAIL int-item-for-PN THEN
       FIND FIRST item-fabric USE-INDEX item-fab NO-LOCK
            WHERE item-fabric.it-codigo          = int-item-for-PN.it-codigo
              AND STRING(item-fabric.cod-fabric) = int-item-for-PN.item-do-forn NO-ERROR.

    IF AVAIL item-fabric THEN
       FIND FIRST item-fornec-estab NO-LOCK
            WHERE item-fornec-estab.it-codigo    = item-fabric.it-codigo
              AND item-fornec-estab.item-do-forn = STRING(item-fabric.cod-fabric)
              AND item-fornec-estab.cod-estabel  = msg0204.CodigoEstabelecimento NO-ERROR.

    IF AVAIL item-fornec-estab THEN
       FIND FIRST int-item-fornec-estab OF item-fornec-estab NO-LOCK NO-ERROR.

    FIND FIRST b-emitente NO-LOCK
        WHERE b-emitente.cod-emitente = i-cod-fornec NO-ERROR.

    FIND FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = ITEM.cod-unid-negoc NO-ERROR.

    FIND FIRST int-pedido-compr NO-LOCK
         WHERE int-pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

    RUN pi-busca-criticidade.

    IF NOT CAN-FIND (FIRST ItemEstoque
                     WHERE ItemEstoque.CodigoProduto = ITEM.it-codigo) THEN DO:
            
            CREATE ItemEstoque.
            ASSIGN ItemEstoque.CodigoProduto                = ITEM.it-codigo
                   ItemEstoque.NomeProduto                  = IF msg0204.I18N AND ITEM.desc-inter <> "" THEN ITEM.desc-inter ELSE ITEM.desc-item
                   ItemEstoque.MatriculaComprador           = IF AVAIL item-uni-estab      THEN item-uni-estab.cod-comprado      ELSE ?
                   ItemEstoque.NomeComprador                = IF AVAIL usuar_mestre        THEN usuar_mestre.nom_usuario         ELSE ?
                   ItemEstoque.QuantidadeEstoqueSeguranca   = de-quant-segur                                                     
                   ItemEstoque.QuantidadePoliticaEstoque    = IF AVAIL int-item-uni-estab  THEN int-item-uni-estab.qtd-pol       ELSE 0
                   ItemEstoque.SaldoInicial                 = de-saldo-inic                                                      
                   ItemEstoque.SaldoTerceiros               = de-saldo-terc                                                      
                   ItemEstoque.CodigoUnidadeConsumo         = ITEM.un                                                            
                   ItemEstoque.DescricaoUnidadeConsumo      = IF AVAIL tab-unidade         THEN tab-unidade.descricao            ELSE ?
                   ItemEstoque.TempoRessuprimentoFornecedor = IF AVAIL item-uni-estab      THEN item-uni-estab.res-for-comp      ELSE ?
                   ItemEstoque.PeriodoFixo                  = IF AVAIL item-uni-estab      THEN item-uni-estab.periodo-fixo      ELSE ?
                   ItemEstoque.DataRessuprimento            = TODAY + item-uni-estab.res-for-comp
                   ItemEstoque.CodigoFornecedorEMS          = IF AVAIL b-item-fornec-estab THEN b-item-fornec-estab.cod-emitente ELSE 0
                   ItemEstoque.NomeAbreviadoFornecedor      = IF AVAIL b-emitente          THEN b-emitente.nome-abrev            ELSE ?
                   ItemEstoque.SituacaoItemEMS              = IF item-uni-estab.cod-obsoleto <> 0 THEN item-uni-estab.cod-obsoleto ELSE 4
                   ItemEstoque.CodigoUnidadeNegocio         = ITEM.cod-unid-negoc    
                   ItemEstoque.NomeUnidadeNegocio           = IF AVAIL unid-negoc          THEN unid-negoc.des-unid-negoc        ELSE ?   
                   ItemEstoque.LoteMultiploItemFornecedor   = IF AVAIL b-item-fornec-estab THEN b-item-fornec-estab.lote-mul-for ELSE 0
                   ItemEstoque.LoteMinimoItemFornecedor     = IF AVAIL b-item-fornec-estab THEN b-item-fornec-estab.lote-minimo  ELSE 0
                   ItemEstoque.NivelCriticidade             = IF AVAIL int-criticidade-item THEN int-criticidade-item.nivel-criticidade ELSE ?
                   ItemEstoque.AcaoAnterior                 = IF AVAIL int-acao-criticidade-item THEN STRING(int-acao-criticidade-item.data-acao) + " - " + int-acao-criticidade-item.comentario-acao ELSE ?
                   ItemEstoque.NecessitaLicencaImportacao   = IF AVAIL ITEM THEN ITEM.log-necessita-li ELSE ?
                   ItemEstoque.NecessitaInspecaoOrigem      = IF AVAIL int-item-fornec-estab THEN int-item-fornec-estab.log-nec-inspec ELSE NO .
                   
             FIND FIRST int-item-uni-estab NO-LOCK
                WHERE int-item-uni-estab.it-codigo    = item-uni-estab.it-codigo
                  AND int-item-uni-estab.cod-estabel  = item-uni-estab.cod-estabel NO-ERROR.
             IF  AVAIL int-item-uni-estab THEN
                 ASSIGN ItemEstoque.ObservacaoLogistica = int-item-uni-estab.observacao.


             FIND FIRST int-item NO-LOCK WHERE int-item.it-codigo = ITEM.it-codigo NO-ERROR.

             IF AVAIL int-item THEN DO: 
                 /*
                 IF int-item.motivo-situacao = 1 THEN
                    ASSIGN ItemEstoque.MotivoSituacaoItem = "Altera‡Æo de estrutura".
                 
                 IF int-item.motivo-situacao = 2 THEN
                    ASSIGN ItemEstoque.MotivoSituacaoItem = "Phase out produto".
                    */

                 CASE int-item.motivo-situacao:
                     WHEN 1 THEN
                        ASSIGN ItemEstoque.MotivoSituacaoItem = "Altera‡Æo de estrutura".
                     WHEN 2 THEN
                        ASSIGN ItemEstoque.MotivoSituacaoItem = "Phase out produto".
                     WHEN 3 THEN
                        ASSIGN ItemEstoque.MotivoSituacaoItem = "Item EOL".
                     WHEN 4 THEN
                        ASSIGN ItemEstoque.MotivoSituacaoItem = "Bloqueado para compra".
                 END CASE.


             END.                                                            
                                                                                                                                             
    END.


/*     IF AVAIL ordem-compra THEN                                       */
/*         ASSIGN c-cod-unid-negoc = ordem-compra.cod-unid-negoc.       */
/*     ELSE                                                             */
/*         ASSIGN c-cod-unid-negoc = tt-estoq.unid-negoc.               */
/*                                                                      */
/*     FIND FIRST unid-negoc NO-LOCK                                    */
/*         WHERE unid-negoc.cod-unid-negoc = c-cod-unid-negoc NO-ERROR. */
/*                                                                      */


    CREATE RegistroEstoque.
    ASSIGN RegistroEstoque.CodigoProduto              = ITEM.it-codigo
           RegistroEstoque.TipoRegistro               = tt-estoq.tipo
           RegistroEstoque.NumeroRegistro             = ENTRY(1,tt-estoq.referencia,"/")
           RegistroEstoque.SequenciaParcela           = IF AVAIL prazo-compra      THEN prazo-compra.parcela      ELSE ?
           RegistroEstoque.NumeroEmbarque             = IF AVAIL ordens-embarque   THEN ordens-embarque.embarque  ELSE ?
           RegistroEstoque.NumeroPedidoCompra         = IF AVAIL ordem-compra      THEN ordem-compra.num-pedido   ELSE ?
           RegistroEstoque.CodigoFornecedorEMS        = IF AVAIL emitente          THEN emitente.cod-emitente     ELSE ?
           RegistroEstoque.NomeAbreviadoFornecedor    = IF AVAIL emitente          THEN emitente.nome-abrev       ELSE ?
           RegistroEstoque.DataEmbarque               = IF AVAIL historico-embarque 
                                                        AND historico-embarque.dt-efetiva <> ? THEN 
                                                            historico-embarque.dt-efetiva 
                                                        ELSE IF AVAIL historico-embarque THEN
                                                            historico-embarque.dt-ult-prev
                                                        ELSE 
                                                            ?
           RegistroEstoque.SituacaoEmbarque           = IF AVAIL tt-emb       THEN tt-emb.situacao           ELSE ?
           RegistroEstoque.ConhecimentoEmbarque       = IF AVAIL tt-emb       THEN tt-emb.conhecimento       ELSE ?
           RegistroEstoque.DataPrevista               = tt-estoq.dt-termino
           RegistroEstoque.Quantidade                 = tt-estoq.quantidade
           RegistroEstoque.SaldoDisponivel            = tt-estoq.saldo
           RegistroEstoque.CodigoPontoControle        = IF AVAIL pto-contr                THEN pto-contr.cod-pto-contr                ELSE ?
           RegistroEstoque.DescricaoPontoControle     = IF AVAIL pto-contr                THEN pto-contr.descricao                    ELSE ?
           RegistroEstoque.LoteMultiploItemFornecedor = IF AVAIL b-item-fornec-estab        THEN b-item-fornec-estab.lote-mul-for         ELSE ?
           RegistroEstoque.LoteMinimoItemFornecedor   = IF AVAIL b-item-fornec-estab        THEN b-item-fornec-estab.lote-minimo          ELSE ?
           RegistroEstoque.ParcelaAnalisada           = IF AVAIL int-analise-ordem-compra THEN int-analise-ordem-compra.log-analisada ELSE NO
           RegistroEstoque.SituacaoOrdemCompra        = IF AVAIL ordem-compra             THEN ordem-compra.situacao                  ELSE ?
           RegistroEstoque.SituacaoAceitePedido       = IF AVAIL int-pedido-compr         THEN int-pedido-compr.SituacaoAceitePedido  ELSE 1
           RegistroEstoque.DataNecessidade            = IF AVAIL int-prazo-compra         THEN int-prazo-compra.data-necessidade      ELSE ?.
/*            RegistroEstoque.CodigoUnidadeNegocio       = IF c-cod-unid-negoc <> ""         THEN c-cod-unid-negoc                       ELSE ?  */
/*            RegistroEstoque.NomeUnidadeNegocio         = IF AVAIL unid-negoc               THEN unid-negoc.des-unid-negoc              ELSE ?. */

    IF RegistroEstoque.SituacaoEmbarque = 98 THEN
        ASSIGN RegistroEstoque.SituacaoEmbarque = 2.


END PROCEDURE.


PROCEDURE pi-busca-posicao :
    
    EMPTY TEMP-TABLE tt-emb.
    FOR EACH embarque-imp NO-LOCK
       WHERE embarque-imp.situacao    = 1
         AND embarque-imp.cod-estabel = msg0204.CodigoEstabelecimento
         AND embarque-imp.embarque    = ordens-embarque.embarque:

        {esp/imp/esimp000.i}        
    END.
END PROCEDURE.

PROCEDURE pi-busca-criticidade:
           
/*     DEFINE VARIABLE i-cd-plano AS INTEGER   NO-UNDO. */
/*                                                      */
/*     CASE msg0204.CodigoEstabelecimento:              */
/*         WHEN "101" THEN                              */
/*             ASSIGN i-cd-plano = 1.                   */
/*         WHEN "104" THEN DO:                          */
/*             IF ITEM.it-codigo >= "4000000"           */
/*                 AND ITEM.it-codigo <= "4999999" THEN */
/*                 ASSIGN i-cd-plano = 4.               */
/*             ELSE                                     */
/*                 ASSIGN i-cd-plano = 41.              */
/*         END.                                         */
/*         WHEN "105" THEN                              */
/*             ASSIGN i-cd-plano = 5.                   */
/*         WHEN "106" THEN                              */
/*             ASSIGN i-cd-plano = 6.                   */
/*         WHEN "107" THEN                              */
/*             ASSIGN i-cd-plano = 7.                   */
/*     END CASE.                                        */

    IF AVAIL ITEM THEN
        FIND LAST int-criticidade-item NO-LOCK 
            WHERE int-criticidade-item.cod-estabel = msg0204.CodigoEstabelecimento
              AND int-criticidade-item.cd-plano    = msg0204.CodigoPlano
              AND int-criticidade-item.it-codigo   = ITEM.it-codigo NO-ERROR.

    /*Busca a £ltima a‡Æo do usu rio "NOT acao-sistema"*/
    FIND LAST int-acao-criticidade-item NO-LOCK
        WHERE int-acao-criticidade-item.cod-estabel     = msg0204.CodigoEstabelecimento 
          AND int-acao-criticidade-item.cd-plano        = msg0204.CodigoPlano           
          AND int-acao-criticidade-item.it-codigo       = ITEM.it-codigo               
          AND NOT int-acao-criticidade-item.acao-sistema NO-ERROR.  
            
END PROCEDURE. 

/* calacula a simulacao de estoque */
{esp/ccp/esccp032.i20}
