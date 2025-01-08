CREATE WIDGET-POOL.

DEFINE VARIABLE h-bocx140   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx140na AS HANDLE      NO-UNDO.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                            */
/*                                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                           */
/*                 <MENSAGEM>                                                                      */
/*                   <CABECALHO>                                                                   */
/*                     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*                     <NumeroOperacao>gu048488-2015-07-01-2015-07-31-2-fr04965</NumeroOperacao>   */
/*                     <CodigoMensagem>MSG0211</CodigoMensagem>                                    */
/*                     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*                   </CABECALHO>                                                                  */
/*                   <CONTEUDO>                                                                    */
/*                         <MSG0211>                                                               */
/*                            <NumeroPedidoCompra>?</NumeroPedidoCompra>                           */
/*                            <SituacaoAceitePedido></SituacaoAceitePedido>                        */
/*                            <MotivoRejeicao></MotivoRejeicao>                                    */
/*                            <CodigoFornecedorEMS>146207</CodigoFornecedorEMS>                    */
/*                            <NaturezaPedido>1</NaturezaPedido>                                   */
/*                            <PedidoEmergencial>YES</PedidoEmergencial>                           */
/*                            <CodigoTipoPedido>1</CodigoTipoPedido>                               */
/*                            <TipoFrete>1</TipoFrete>                                             */
/*                            <CodigoTransportadora>368</CodigoTransportadora>                     */
/*                            <CodigoViaTransporte>1</CodigoViaTransporte>                         */
/*                            <CodigoEstabelecimentoEntrega>104</CodigoEstabelecimentoEntrega>     */
/*                            <CodigoEstabelecimentoCobranca>104</CodigoEstabelecimentoCobranca>   */
/*                            <CodigoCondicaoPagamento>181</CodigoCondicaoPagamento>               */
/*                            <MatriculaResponsavel>ga046926</MatriculaResponsavel>                */
/*                            <CodigoMensagemPedido>810</CodigoMensagemPedido>                     */
/*                            <NarrativaPedido>narrativa</NarrativaPedido>                         */
/*                         </MSG0211>                                                              */
/*                   </CONTEUDO>                                                                   */
/*                 </MENSAGEM>".                                                                   */

{esp/esb/in/msg0211.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0211
   DATA-RELATION FOR conteudo, MSG0211           RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0211R1, resultado
   DATA-RELATION FOR conteudor, MSG0211R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0211R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0211R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0211 NO-ERROR.

CREATE conteudor.
CREATE MSG0211R1.
CREATE resultado.

RUN pi-gera-pedido.

IF VALID-HANDLE(h-boin295)   THEN DO:
    DELETE PROCEDURE h-boin295.
                     h-boin295 = ?.
END.

IF VALID-HANDLE(h-bocx140) THEN DO:
    DELETE PROCEDURE h-bocx140 NO-ERROR.
    ASSIGN h-bocx140 = ?.
END.

IF  RETURN-VALUE <> "OK" THEN DO:
    
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-gera-pedido:

    blk_pedido:
    DO TRANSACTION
    ON ERROR UNDO blk_pedido, LEAVE blk_pedido
    ON STOP  UNDO blk_pedido, LEAVE blk_pedido: 

        RUN inbo/boin295.p  PERSISTENT SET h-boin295.
        RUN openQueryStatic IN h-boin295 (INPUT "Main":U).

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = MSG0211.CodigoFornecedorEMS NO-ERROR.
    
        /*Altera pedido existente*/
        IF MSG0211.NumeroPedidoCompra <> ? THEN DO:
            FIND FIRST pedido-compr NO-LOCK
                 WHERE pedido-compr.num-pedido = MSG0211.NumeroPedidoCompra NO-ERROR.

            IF NOT AVAIL pedido-compr THEN DO:
                RUN pi-erro (INPUT "Pedido: " + STRING(MSG0211.NumeroPedidoCompra) + " n∆o encontrado.").
                RETURN "NOK".
            END.
            
            RUN emptyRowErrors IN h-boin295.
            RUN goToKey        IN h-boin295 (INPUT MSG0211.NumeroPedidoCompra).
            RUN getRecord      IN h-boin295 (OUTPUT TABLE tt-pedido-compr).

            IF RETURN-VALUE = "OK" THEN DO:
                FIND FIRST tt-pedido-compr NO-ERROR.
    
                ASSIGN tt-pedido-compr.cod-emitente = MSG0211.CodigoFornecedorEMS           
                       tt-pedido-compr.natureza     = MSG0211.NaturezaPedido                
                       tt-pedido-compr.emergencial  = MSG0211.PedidoEmergencial             
                       tt-pedido-compr.frete        = MSG0211.TipoFrete                     
                       tt-pedido-compr.cod-transp   = MSG0211.CodigoTransportadora          
                       tt-pedido-compr.via-transp   = MSG0211.CodigoViaTransporte           
                       tt-pedido-compr.end-entrega  = MSG0211.CodigoEstabelecimentoEntrega  
                       tt-pedido-compr.end-cobranca = MSG0211.CodigoEstabelecimentoCobranca 
                       tt-pedido-compr.cod-cond-pag = MSG0211.CodigoCondicaoPagamento       
                       tt-pedido-compr.responsavel  = MSG0211.MatriculaResponsavel          
                       tt-pedido-compr.cod-mensagem = MSG0211.CodigoMensagemPedido          
                       tt-pedido-compr.comentarios  = MSG0211.NarrativaPedido.    
                
                RUN setRecord    IN h-boin295 (INPUT TABLE tt-pedido-compr).
                RUN updateRecord IN h-boin295.
                RUN getRowErrors IN h-boin295 (OUTPUT TABLE RowErrors).
            END.
            
            IF CAN-FIND (FIRST RowErrors) THEN DO:
                FOR EACH RowErrors NO-LOCK                                                                                                    
                   WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                     AND RowErrors.ErrorSubType = "Error":U:  
                    RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                    UNDO blk_pedido, LEAVE blk_pedido.
                END. 
            END.

            RUN pi-int-ped-compr.

            /*Salva n£mero do pedido alterado no retorno*/
            ASSIGN MSG0211R1.NumeroPedidoCompra = MSG0211.NumeroPedidoCompra.
        END.

        /*Cria novo pedido*/
        ELSE DO:
    
            CREATE tt-pedido-compr.
            ASSIGN tt-pedido-compr.cod-emitente = MSG0211.CodigoFornecedorEMS           
                   tt-pedido-compr.natureza     = MSG0211.NaturezaPedido                
                   tt-pedido-compr.emergencial  = MSG0211.PedidoEmergencial             
                   tt-pedido-compr.frete        = MSG0211.TipoFrete                     
                   tt-pedido-compr.cod-transp   = MSG0211.CodigoTransportadora          
                   tt-pedido-compr.via-transp   = MSG0211.CodigoViaTransporte           
                   tt-pedido-compr.end-entrega  = MSG0211.CodigoEstabelecimentoEntrega  
                   tt-pedido-compr.end-cobranca = MSG0211.CodigoEstabelecimentoCobranca 
                   tt-pedido-compr.cod-cond-pag = MSG0211.CodigoCondicaoPagamento       
                   tt-pedido-compr.responsavel  = MSG0211.MatriculaResponsavel          
                   tt-pedido-compr.cod-mensagem = MSG0211.CodigoMensagemPedido          
                   tt-pedido-compr.comentarios  = MSG0211.NarrativaPedido.
        
            /*BO criaá∆o do pedido*/
            RUN emptyRowErrors         IN h-boin295.
            RUN geraNumeroPedidoCompra IN h-boin295 (OUTPUT i-num-pedido).
        
            ASSIGN tt-pedido-compr.num-pedido = i-num-pedido.

            RUN setRecord    IN h-boin295 (INPUT TABLE tt-pedido-compr).
            RUN createRecord IN h-boin295.
            RUN getRowErrors IN h-boin295 (OUTPUT TABLE RowErrors).

            IF CAN-FIND (FIRST RowErrors) THEN DO:
                FOR EACH RowErrors NO-LOCK                                                                                                    
                   WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                     AND RowErrors.ErrorSubType = "Error":U:  
                    RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                    UNDO blk_pedido, LEAVE blk_pedido.
                END. 
            END.

            RUN pi-int-ped-compr.

            /*Salva n£mero do pedido criado no retorno*/
            ASSIGN MSG0211R1.NumeroPedidoCompra = tt-pedido-compr.num-pedido.

            /*Marca od pedido gerados como impresso*/
            FIND FIRST pedido-compr EXCLUSIVE-LOCK
                 WHERE pedido-compr.num-pedido = tt-pedido-compr.num-pedido NO-ERROR.

            IF  AVAIL pedido-compr
            AND pedido-compr.situacao <> 1 /*Impresso*/ THEN 
                ASSIGN pedido-compr.situacao = 1.

            RELEASE pedido-compr.
        END.

        /*Grava follow-up*/
        IF  MSG0211.HistoricoPedidoCompra <> ""
        AND MSG0211.HistoricoPedidoCompra <> ? THEN DO:

            /*Busca sequencia*/
            ASSIGN i-seq-follow = 1.
            FOR LAST texto-follow-up NO-LOCK
               WHERE texto-follow-up.num-pedido = MSG0211R1.NumeroPedidoCompra:

                ASSIGN i-seq-follow = texto-follow-up.seq-narra + 1.
            END.

            ASSIGN c-header = "Usu†rio: " + cabecalho.LoginUsuario.
            
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.num-pedido = tt-pedido-compr.num-pedido NO-ERROR.

            create texto-follow-up.
            assign texto-follow-up.cod-emitente    = tt-pedido-compr.cod-emitente
                   texto-follow-up.des-narrativa   = c-header + CHR(10) + HistoricoPedidoCompra
                   texto-follow-up.ind-tip-doc     = 6
                   texto-follow-up.it-codigo       = IF AVAIL ordem-compra THEN ordem-compra.it-codigo ELSE ""
                   texto-follow-up.nr-requisicao   = 0
                   texto-follow-up.num-pedido      = MSG0211R1.NumeroPedidoCompra
                   texto-follow-up.numero-ordem    = IF AVAIL ordem-compra THEN ordem-compra.numero-ordem ELSE 0
                   texto-follow-up.parcela         = 0
                   texto-follow-up.seq-narra       = i-seq-follow
                   texto-follow-up.sequencia       = 3
                   texto-follow-up.Dat-alter       = TODAY
                   texto-follow-up.hra-alter 	   = STRING(TIME,"hh:mm:ss")
                   texto-follow-up.cod-usuar-alter = cabecalho.LoginUsuario.
        END.
    END.
    
    IF NOT CAN-FIND (FIRST tt-erro) THEN
        RETURN "OK".
    ELSE 
        RETURN "NOK".
END PROCEDURE.

PROCEDURE pi-int-ped-compr.

    FIND FIRST pedido-compr NO-LOCK
         WHERE pedido-compr.num-pedido = tt-pedido-compr.num-pedido NO-ERROR.

    FIND FIRST int-pedido-compr EXCLUSIVE-LOCK
         WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-ERROR.

    IF NOT AVAIL int-pedido-compr THEN DO:
        /*Cria extená∆o do pedido*/
        CREATE int-pedido-compr.
        ASSIGN int-pedido-compr.num-pedido = pedido-compr.num-pedido.
    END.
    
    ASSIGN int-pedido-compr.tp-pedido            = msg0211.CodigoTipoPedido
           int-pedido-compr.SituacaoAceitePedido = msg0211.SituacaoAceitePedido 
           int-pedido-compr.MotivoRejeicao       = msg0211.MotivoRejeicao
           int-pedido-compr.cod-produto-ckd      = msg0211.CodigoCKD     
           int-pedido-compr.qtd-pedido-ckd       = msg0211.QuantidadeCKD.

    FIND CURRENT int-pedido-compr NO-LOCK.
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
