CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                            */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>294442/558767-gi041250</NumeroOperacao>                     */
/*     <CodigoMensagem>MSG0210</CodigoMensagem>                                    */
/*     <LoginUsuario>gi041250</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0210>                                                                   */
/*       <MatriculaUsuario>gi041250</MatriculaUsuario>                             */
/*       <CancelarOrdemCompra>                                                     */
/*         <NumeroPedidoCompra>294442</NumeroPedidoCompra>                         */
/*         <NumeroOrdemCompra>558767</NumeroOrdemCompra>                           */
/*         <MotivoCancelamento>Reteste gizelle</MotivoCancelamento>                */
/*       </CancelarOrdemCompra>                                                    */
/*     </MSG0210>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0210.i}

DEFINE VARIABLE h-boin356vl AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin356   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin356na AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx225na AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin295   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin274vl AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin274   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx140na AS HANDLE NO-UNDO.

DEFINE VARIABLE c-situacao-pai    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-situacao-pedido AS CHARACTER   NO-UNDO.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0210, CancelarPedidoCompra, CancelarOrdemCompra, CancelarParcela 
   DATA-RELATION FOR conteudo, MSG0210              RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0210,  CancelarPedidoCompra RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0210,  CancelarOrdemCompra  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0210,  CancelarParcela      RELATION-FIELDS (idm, idm) NESTED.
 
DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0210_R1, resultado
   DATA-RELATION FOR conteudor, MSG0210_R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0210_R1, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0210R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0210 NO-ERROR.

CREATE conteudor.
CREATE MSG0210_R1.
CREATE resultado.

RUN pi-cancela.
RUN pi-elimina-handle.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* DEFINE VARIABLE hDoc AS HANDLE   NO-UNDO.                                                    */
/* CREATE X-DOCUMENT hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-cancela:
    
    RUN pi-cancela-parcela.

    RUN pi-cancela-ordem.

    RUN pi-cancela-pedido.
    
    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".
    ELSE 
        RETURN "OK".
END PROCEDURE.

PROCEDURE pi-cancela-parcela:

    blk_parcela:
    DO TRANSACTION
    ON ERROR UNDO blk_parcela, LEAVE blk_parcela
    ON STOP  UNDO blk_parcela, LEAVE blk_parcela:            

        FOR EACH CancelarParcela:
            
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = CancelarParcela.NumeroOrdemCompra NO-ERROR.

            IF NOT AVAIL ordem-compra THEN DO:
                RUN pi-erro (INPUT "N∆o encontrada ordem de compra: " + STRING( CancelarParcela.NumeroOrdemCompra)).
            END.

            FIND FIRST pedido-compr NO-LOCK
                 WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.
    
            FIND FIRST prazo-compra NO-LOCK
                 WHERE prazo-compra.numero-ordem = CancelarParcela.NumeroOrdemCompra
                   AND prazo-compra.parcela      = CancelarParcela.SequenciaParcela NO-ERROR.

            IF NOT AVAIL prazo-compra THEN DO:
                RUN pi-erro (INPUT "Parcela n∆o encontrada").
            END.

            IF CAN-FIND (FIRST ordens-embarque
                         WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                           AND ordens-embarque.parcela      = prazo-compra.parcela) THEN DO:
                RUN pi-erro (INPUT "Parcela " + STRING(prazo-compra.parcela) + " da ordem " + STRING(prazo-compra.numero-ordem) + " possui embarque vinculado.").
            END.

            IF CAN-FIND (FIRST tt-erro) THEN DO:
                UNDO blk_parcela, LEAVE blk_parcela.
            END.

            /*BO prazo-compra (validacoes)*/
            IF NOT VALID-HANDLE(h-boin356vl) THEN
                RUN inbo/boin356vl.p PERSISTENT SET h-boin356vl.
        
            /*BO prazo-compra*/
            IF NOT VALID-HANDLE(h-boin356) THEN
                RUN inbo/boin356.p PERSISTENT SET h-boin356.
        
            RUN openQueryStatic IN h-boin356 (INPUT "Main":U).
    
            RUN emptyRowErrors IN h-boin356vl.
            RUN setaParamType  IN h-boin356vl (INPUT "DEL":U).
            RUN validaModificacaoPrazoCompra IN h-boin356vl(ROWID(prazo-compra)).
        
            IF AVAIL pedido-compr THEN DO:
                /*Seguranáa Usu†rio*/
                RUN validateSegcc0300 IN h-boin356vl (INPUT 3,
                                                      INPUT pedido-compr.emergencial,
                                                      INPUT pedido-compr.situacao).
            END.

            RUN getRowErrors IN h-boin356vl (OUTPUT TABLE RowErrors).
            
            IF CAN-FIND (FIRST RowErrors) THEN DO:
                FOR EACH RowErrors NO-LOCK                                                                                                    
                   WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                     AND RowErrors.ErrorSubType = "Error":U:  
                    RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                    UNDO blk_parcela, LEAVE blk_parcela.
                END. 
            END.

            IF  AVAIL pedido-compr
            AND pedido-compr.situacao = 1 /*Impresso*/ THEN DO:
                IF prazo-compra.quant-receb > 0 
                OR prazo-compra.dec-1       > 0 THEN DO:
                   
                   RUN utp/ut-msgs.p(input "MSG":U,
                                     INPUT 34324,
                                     INPUT "Parcela de Compra").
    
                   RUN pi-erro (INPUT RETURN-VALUE).  
                   UNDO blk_parcela, LEAVE blk_parcela.
               END.

               /*Cria a temp-table com o motivo da eliminaá∆o*/
               FIND FIRST tt-motivo-elimina
                    WHERE tt-motivo-elimina.numero-ordem = prazo-compra.numero-ordem 
                      AND tt-motivo-elimina.parcela      = prazo-compra.parcela NO-ERROR.
    
               IF NOT AVAIL tt-motivo-elimina THEN DO:
                   CREATE tt-motivo-elimina.
                   ASSIGN tt-motivo-elimina.numero-ordem = prazo-compra.numero-ordem
                          tt-motivo-elimina.parcela      = prazo-compra.parcela
                          tt-motivo-elimina.motivo       = CancelarParcela.MotivoCancelamento.
               END.
            END.
            ELSE DO: /* N∆o Impresso / sem pedido*/
                RUN emptyRowErrors IN h-boin356.
                RUN gotokey in h-boin356 (input prazo-compra.numero-ordem,
                                          input prazo-compra.parcela).
            
                RUN informaTipoValidacaoDelete IN h-boin356 (INPUT YES).
                RUN validateRecord IN h-boin356(INPUT "DELETE":U).
                RUN getRowErrors   IN h-boin356 (OUTPUT TABLE RowErrors).

                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    FOR EACH RowErrors NO-LOCK                                                                                                    
                       WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                         AND RowErrors.ErrorSubType = "Error":U:  
                        RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                        UNDO blk_parcela, LEAVE blk_parcela.
                    END.
                END.
            END.
        
            IF NOT CAN-FIND(FIRST tt-prazo-eliminado 
                            WHERE tt-prazo-eliminado.parcela      = prazo-compra.parcela
                              AND tt-prazo-eliminado.numero-ordem = prazo-compra.numero-ordem) THEN DO:
        
                CREATE tt-prazo-eliminado.
                BUFFER-COPY prazo-compra TO tt-prazo-eliminado.
            END.
        END. /*FOR EACH Parcela*/
    
        /*Eliminacao da parcela*/
        RUN inbo/boin356na.p PERSISTENT SET h-boin356na.
        FOR EACH tt-prazo-eliminado:
            RUN setRecord IN h-boin356 (INPUT TABLE tt-prazo-eliminado).
            RUN gotoKey   IN h-boin356 (INPUT tt-prazo-eliminado.numero-ordem,
                                        INPUT tt-prazo-eliminado.parcela).
            
            IF RETURN-VALUE = "OK" THEN DO:
                /*Sem pedido ou pedido diferente de impresso*/
                IF NOT AVAIL pedido-compr
                OR pedido-compr.situacao <> 1 THEN DO: 
                    
                    RUN informaTipoValidacaoDelete in h-boin356 (INPUT YES).
                    
                    RUN deleteRecord IN h-boin356.
                    RUN getRowErrors IN h-boin356 (OUTPUT TABLE RowErrors).
        
                    IF CAN-FIND (FIRST RowErrors) THEN DO:
                        FOR EACH RowErrors NO-LOCK                                                                                                    
                           WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                             AND RowErrors.ErrorSubType = "Error":U:  
                            RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                            UNDO blk_parcela, LEAVE blk_parcela.
                        END. 
                    END.

                    /*/*Quando exclui a unica parcela da ordem cria um registro na temp-table para exclus∆o da ordem de compra*/
                    IF NOT CAN-FIND (FIRST prazo-compra
                                     WHERE prazo-compra.numero-ordem = tt-prazo-eliminado.numero-ordem) THEN DO:

                        CREATE CancelarOrdemCompra.
                        ASSIGN CancelarOrdemCompra.NumeroPedidoCompra = IF AVAIL pedido-compr THEN pedido-compr.num-pedido ELSE ?
                               CancelarOrdemCompra.NumeroOrdemCompra  = tt-prazo-eliminado.numero-ordem.
                    END.*/
                END.
                ELSE IF  AVAIL pedido-compr
                 AND pedido-compr.situacao = 1 THEN DO: /* pedido impresso */

                    FIND FIRST tt-motivo-elimina
                         WHERE tt-motivo-elimina.parcela      = tt-prazo-eliminado.parcela
                           AND tt-motivo-elimina.numero-ordem = tt-prazo-eliminado.numero-ordem NO-ERROR.
                    
                    RUN getRowid IN h-boin356(OUTPUT tt-prazo-eliminado.r-rowid).
    
                    IF AVAIL tt-motivo-elimina THEN DO:
                        RUN eliminaParcelaPrazoCompra IN h-boin356na (INPUT msg0210.MatriculaComprador, /* usuario do sistema */
                                                                      INPUT ROWID(pedido-compr),
                                                                      INPUT ROWID(ordem-compra),
                                                                      INPUT tt-prazo-eliminado.r-rowid,
                                                                      INPUT tt-motivo-elimina.motivo).
                    END.
                END.
            END.
    
            DELETE tt-prazo-eliminado.
        END.
        RUN pi-elimina-handle.
    END. /*blk_parcela*/
END PROCEDURE.

PROCEDURE pi-cancela-ordem:

    blk_ordem:
    DO TRANSACTION
    ON ERROR UNDO blk_ordem, LEAVE blk_ordem
    ON STOP  UNDO blk_ordem, LEAVE blk_ordem:       

        FOR EACH CancelarOrdemCompra
           WHERE CancelarOrdemCompra.NumeroPedidoCompra <> ?:

            FIND FIRST pedido-compr NO-LOCK
                 WHERE pedido-compr.num-pedido = CancelarOrdemCompra.NumeroPedidoCompra NO-ERROR.
    
            IF NOT AVAIL pedido-compr THEN DO:
                RUN pi-erro (INPUT "N∆o encontrado pedido de compra: " + STRING(CancelarOrdemCompra.NumeroPedidoCompra)).
            END.
    
            FIND FIRST ordem-compra NO-LOCK 
                 WHERE ordem-compra.numero-ordem = CancelarOrdemCompra.NumeroOrdemCompra NO-ERROR.
    
            IF NOT AVAIL ordem-compra THEN DO:
                RUN pi-erro (INPUT "N∆o encontrada ordem de compra: " + STRING(CancelarOrdemCompra.NumeroOrdemCompra)).
            END.

            IF CancelarOrdemCompra.NumeroPedidoCompra <> ordem-compra.num-pedido THEN DO:
                RUN pi-erro (INPUT "Pedido: " + STRING(CancelarOrdemCompra.NumeroPedidoCompra) + " n∆o pertence a ordem de compra: " + STRING(CancelarOrdemCompra.NumeroOrdemCompra)).
            END.
            
            IF CAN-FIND (FIRST tt-erro) THEN DO:
                UNDO blk_ordem, LEAVE blk_ordem.
            END.
    
            RUN inbo/boin295.p PERSISTENT SET h-boin295.
            RUN openQueryStatic IN h-boin295 (INPUT "Main":U).
        
            RUN cxbo/bocx225na.p PERSISTENT SET h-bocx225na.
            RUN openQueryStatic IN h-bocx225na (INPUT "Main":U).
    
            RUN goToOrdemcompra IN h-bocx225na (INPUT ordem-compra.numero-ordem).
    
            IF RETURN-VALUE = "OK" 
            OR RETURN-VALUE = "" THEN DO:
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 5,
                                   INPUT "Ordem de Compra" + "~~" + "Embarque").
        
                RUN pi-erro (INPUT RETURN-VALUE).
                UNDO blk_ordem, LEAVE blk_ordem.
            END.  

            RUN inbo/boin274vl.p PERSISTENT SET h-boin274vl.

            RUN emptyRowErrors IN h-boin295.
            RUN verificCentralPedidoCompra IN h-boin295 (INPUT  ROWID(pedido-compr), 
                                                         OUTPUT c-situacao-pai).
        
            RUN getRowErrors IN h-boin295 (OUTPUT TABLE RowErrors).
            
            IF CAN-FIND (FIRST RowErrors) THEN DO:
                FOR EACH RowErrors NO-LOCK                                                                                                    
                   WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                     AND RowErrors.ErrorSubType = "Error":U:  
                    RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                    UNDO blk_ordem, LEAVE blk_ordem.
                END. 
            END.
        
            /*Seguranáa de Usu†rio*/
            RUN emptyRowErrors    IN h-boin274vl.
            RUN validateSegcc0300 IN h-boin274vl (INPUT 3,
                                                  INPUT pedido-compr.num-pedido).
        
            RUN validaEliminacaoOrdemCompra IN h-boin274vl (INPUT ROWID(ordem-compra)).
        
            RUN getRowErrors IN h-boin274vl (OUTPUT TABLE RowErrors).
            
            IF CAN-FIND (FIRST RowErrors) THEN DO:
                FOR EACH RowErrors NO-LOCK                                                                                                    
                   WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                     AND RowErrors.ErrorSubType = "Error":U:  
                    RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                    UNDO blk_ordem, LEAVE blk_ordem.
                END. 
            END.
    
            IF pedido-compr.situacao = 1 
            OR pedido-compr.situacao = 2 THEN DO:    
                
                IF pedido-compr.situacao = 1 THEN DO: /*Impresso*/
                    
                     RUN inbo/boin274vl.p PERSISTENT SET h-boin274.
                     
                     RUN eliminaOrdensCompraComMultiPlanta in h-boin274 (INPUT ROWID(ordem-compra),
                                                                         INPUT "", /* usu†rio do sistema */
                                                                         INPUT CancelarOrdemCompra.MotivoCancelamento,
                                                                         INPUT YES).
    
                     RUN inbo/boin356vl.p PERSISTENT SET h-boin356vl.
        
                     RUN atualizaSituacaoProcessoImportacao IN h-boin356vl (INPUT pedido-compr.num-pedido,
                                                                            INPUT pedido-compr.cod-emitente,
                                                                            INPUT pedido-compr.cod-estabel).
                END.
                ELSE DO: /*N∆o Impresso*/
                    
                    RUN emptyRowErrors                    IN h-boin295.
                    RUN validDesfazRelacOrdemCompraPedido IN h-boin295 (INPUT ROWID(ordem-compra)).
                    RUN getRowErrors                      IN h-boin295 (OUTPUT TABLE RowErrors).
                    
                    IF CAN-FIND (FIRST RowErrors) THEN DO:
                        FOR EACH RowErrors NO-LOCK                                                                                                    
                           WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                             AND RowErrors.ErrorSubType = "Error":U:  
                            RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                            UNDO blk_ordem, LEAVE blk_ordem.
                        END. 
                    END.
        
                    RUN desfazRelacOrdemPedido IN h-boin295 (INPUT ROWID(ordem-compra)).

                    /*/*Quando exclui a £nica ordem do pedido cria um registro na temp-table para exclus∆o do pedido de compra*/
                    IF NOT CAN-FIND (FIRST ordem-compra
                                     WHERE ordem-compra.num-pedido = pedido-compr.num-pedido) THEN DO:
                        CREATE CancelarPedidoCompra.
                        ASSIGN CancelarPedidoCompra.NumeroPedidoCompra = pedido-compr.num-pedido.
                    END.*/
                END.
            END.
            ELSE DO: /*Pedido eliminado*/
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 6003,
                                   INPUT "").
        
                RUN pi-erro (INPUT RETURN-VALUE).    
                UNDO blk_ordem, LEAVE blk_ordem.
            END.
    
            RUN pi-elimina-handle.
        END.
    
        FOR EACH CancelarOrdemCompra
           WHERE CancelarOrdemCompra.NumeroPedidoCompra = ?:
    
            FIND FIRST ordem-compra EXCLUSIVE-LOCK
                 WHERE ordem-compra.numero-ordem = CancelarOrdemCompra.NumeroOrdemCompra NO-ERROR.
    
            IF NOT AVAIL ordem-compra THEN DO:
                RUN pi-erro (INPUT "N∆o encontrada ordem de compra: " + STRING(CancelarOrdemCompra.NumeroOrdemCompra)).
            END.
    
            IF  AVAIL ordem-compra 
            AND ordem-compra.num-pedido <> 0 THEN DO:
                RUN pi-erro (INPUT "Ordem de compra: " + STRING(CancelarOrdemCompra.NumeroOrdemCompra) + " possui pedido relacionado").
            END.

            IF CAN-FIND (FIRST tt-erro) THEN DO:
                UNDO blk_ordem, LEAVE blk_ordem.
            END.
    
            DISABLE TRIGGERS FOR LOAD OF ordem-compra.
            DISABLE TRIGGERS FOR LOAD OF cotacao-item-cex.
            DISABLE TRIGGERS FOR LOAD OF cotacao-item.
            DISABLE TRIGGERS FOR LOAD OF prazo-compra.
            DISABLE TRIGGERS FOR LOAD OF texto-follow-up.
            DISABLE TRIGGERS FOR LOAD OF unid-neg-ordem.
    
            /*Eliminar Despesas Adicionais de Importaá∆o das Cotaá‰es do Item*/
            FOR EACH cotacao-item-cex EXCLUSIVE-LOCK
               WHERE cotacao-item-cex.numero-ordem = ordem-compra.numero-ordem:
                DELETE cotacao-item-cex.
            END.
        
            /*Eliminar Cotaá‰es do Item*/
            FOR EACH cotacao-item EXCLUSIVE-LOCK
               WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem:
                DELETE cotacao-item.
            END.
    
            /*Eliminar Parcelas da Ordem de Compra*/
            FOR EACH prazo-compra EXCLUSIVE-LOCK
               WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                DELETE prazo-compra.
            END.
    
            /*Eliminar Texto Follow-Up*/
            FOR EACH texto-follow-up EXCLUSIVE-LOCK
               WHERE texto-follow-up.numero-ordem = ordem-compra.numero-ordem:
                DELETE texto-follow-up.
            END.
    
            /*Eliminar Integraá∆o Unidade de Neg¢cio*/
            FIND FIRST param-mat NO-LOCK NO-ERROR.
    
            IF  AVAILABLE param-mat    
            AND param-mat.ind-unid-neg THEN DO:
                FOR EACH unid-neg-ordem EXCLUSIVE-LOCK
                   WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem:
                    DELETE unid-neg-ordem.
                END.
            END.
    
            DELETE ordem-compra.
        END.
    END. /*blk_ordem*/
END PROCEDURE.

PROCEDURE pi-cancela-pedido:

    blk_pedido:
    FOR EACH CancelarPedidoCompra:

        FIND FIRST pedido-compr NO-LOCK
             WHERE pedido-compr.num-pedido = CancelarPedidoCompra.NumeroPedidoCompra NO-ERROR.

        IF NOT AVAIL pedido-compr THEN DO:
            RUN pi-erro (INPUT "N∆o encontrado pedido de compra: " + STRING(CancelarPedidoCompra.NumeroPedidoCompra)).
        END.

        IF CAN-FIND (FIRST tt-erro) THEN DO:
            UNDO blk_pedido, LEAVE blk_pedido.
        END.

        RUN inbo/boin295.p PERSISTENT SET h-boin295.
        RUN openQueryStatic IN h-boin295 (INPUT "Main":U).

        RUN cxbo/bocx140na.p PERSISTENT SET h-bocx140na.
        RUN openQueryStatic IN h-bocx140na (INPUT "Main":U).
        RUN goToPedido      IN h-bocx140na (INPUT pedido-compr.num-pedido).

        IF RETURN-VALUE = "OK" 
        OR RETURN-VALUE = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 5,
                               INPUT "Pedido de Compra" + "~~" + "Processo de Importaá∆o").
    
            RUN pi-erro (INPUT RETURN-VALUE).       
            UNDO blk_pedido, LEAVE blk_pedido.
        END.     

        RUN emptyRowErrors             IN h-boin295.
        RUN verificCentralPedidoCompra IN h-boin295 (INPUT  ROWID(pedido-compr),
                                                     OUTPUT c-situacao-pedido).

        RUN inbo/boin274vl.p PERSISTENT SET h-boin274vl.

        RUN emptyRowErrors    IN h-boin274vl.
        RUN validateSegcc0300 IN h-boin274vl (INPUT 3,
                                              INPUT pedido-compr.num-pedido).
    
        RUN validaEliminacaoPedidoCompra IN h-boin274vl (INPUT ROWID(pedido)).
        RUN getRowErrors IN h-boin274vl (OUTPUT TABLE RowErrors).

        IF CAN-FIND (FIRST RowErrors) THEN DO:
            FOR EACH RowErrors NO-LOCK                                                                                                    
               WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                 AND RowErrors.ErrorSubType = "Error":U:  
                RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                UNDO blk_pedido, LEAVE blk_pedido.
            END. 
        END.
    
        RUN validateSegcc0300 IN h-boin295 (INPUT "Delete",
                                            INPUT pedido-compr.emergencial,
                                            INPUT pedido-compr.situacao).

        RUN getRowErrors IN h-boin295 (OUTPUT TABLE RowErrors).
        
        IF CAN-FIND (FIRST RowErrors) THEN DO:
            FOR EACH RowErrors NO-LOCK                                                                                                    
               WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                 AND RowErrors.ErrorSubType = "Error":U:  
                RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                UNDO blk_pedido, LEAVE blk_pedido.
            END. 
        END.

        /*excluir automaticamente processo de importaá∆o*/
        RUN pi-elimina-processo-imp (INPUT pedido-compr.num-pedido).
        IF RETURN-VALUE <> "OK" THEN
            UNDO blk_pedido, LEAVE blk_pedido.

        IF pedido-compr.situacao = 1 /*Impresso*/ 
        OR pedido-compr.situacao = 2 THEN DO:
            
            IF pedido-compr.situacao = 1 THEN DO: /*Impresso*/
    
                 RUN eliminaPedidoCompra IN h-boin295 (INPUT ROWID(pedido-compr), 
                                                       INPUT "", 
                                                       INPUT CancelarPedidoCompra.MotivoCancelamento).
                 
                RUN aprovEletronicaDeletePedido IN h-boin295 (INPUT pedido-compr.num-pedido).
            END.
            ELSE DO: /*N∆o Impresso*/
                
                RUN aprovEletronicaDeletePedido IN h-boin295 (INPUT pedido-compr.num-pedido).
                RUN repositionRecord            IN h-boin295 (INPUT ROWID(pedido-compr)).
                RUN deleteRecord                IN h-boin295.
                
                RUN getRowErrors IN h-boin295 (OUTPUT TABLE RowErrors).
        
                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    FOR EACH RowErrors NO-LOCK                                                                                                    
                       WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                         AND RowErrors.ErrorSubType = "Error":U:  
                        
                        RUN pi-erro (INPUT RowErrors.errorDescription).                                                                                                                                                                                       
                        UNDO blk_pedido, LEAVE blk_pedido.
                    END. 
                END.
            END.
        END.
        ELSE DO: /*Pedido Eliminado*/
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 6003,
                               INPUT "").
    
            RUN pi-erro (INPUT RETURN-VALUE).
            UNDO blk_pedido, LEAVE blk_pedido.
        END.
        
        RUN pi-elimina-handle.

        IF CAN-FIND (FIRST tt-erro) THEN
            UNDO blk_pedido, LEAVE blk_pedido.
    END.
END PROCEDURE.

PROCEDURE pi-elimina-handle:
   IF VALID-HANDLE(h-boin356vl) THEN DO:
       DELETE PROCEDURE h-boin356vl.
                        h-boin356vl = ?.
   END.
   
   IF VALID-HANDLE(h-boin356)   THEN DO:
       DELETE PROCEDURE h-boin356.
                        h-boin356 = ?.
   END.
   
   IF VALID-HANDLE(h-boin356na) THEN DO: 
       DELETE PROCEDURE h-boin356na.
                        h-boin356na = ?.
   END.
   
   IF VALID-HANDLE(h-bocx225na) THEN DO: 
       DELETE PROCEDURE h-bocx225na.
                        h-bocx225na = ?.
   END.
   
   IF VALID-HANDLE(h-boin295)   THEN DO:
       DELETE PROCEDURE h-boin295.
                        h-boin295 = ?.
   END.
   
   IF VALID-HANDLE(h-boin274vl) THEN DO: 
       DELETE PROCEDURE h-boin274vl.
                        h-boin274vl = ?.
   END.
   
   IF VALID-HANDLE(h-boin274)   THEN DO:
       DELETE PROCEDURE h-boin274.
                        h-boin274 = ?.
   END.
   
   IF VALID-HANDLE(h-bocx140na) THEN DO: 
       DELETE PROCEDURE h-bocx140na.
                        h-bocx140na = ?.
   END.
END PROCEDURE.

PROCEDURE pi-elimina-processo-imp:
    DEFINE INPUT PARAM p-num-pedido LIKE pedido-compr.num-pedido.

    DEFINE VARIABLE r-row     AS ROWID       NO-UNDO.

    FIND FIRST pedido-compr NO-LOCK
         WHERE pedido-compr.num-pedido = p-num-pedido NO-ERROR.

    IF NOT AVAIL pedido-compr THEN DO:
        RUN pi-erro (INPUT "N∆o encontrado pedido n£mero: " + STRING(p-num-pedido)).
        RETURN "NOK".
    END.

    FIND FIRST processo-imp NO-LOCK
         WHERE processo-imp.num-pedido = pedido-compr.num-pedido NO-ERROR.

    /*Se n∆o possui processo de importaá∆o retorna*/
    IF NOT AVAIL processo-imp THEN DO:
        RETURN "OK".
    END.

    RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.
    RUN openQuery      IN  h-bocx140 (INPUT 1).

    ASSIGN r-row = ROWID(processo-imp).

    RUN validateDelete IN h-bocx140 (INPUT-OUTPUT r-row,
                                     OUTPUT TABLE RowErrors).    

    DELETE PROCEDURE h-bocx140.
    ASSIGN h-bocx140 = ?.

    IF CAN-FIND (FIRST RowErrors) THEN DO:
        FOR EACH RowErrors NO-LOCK:  
            RUN pi-erro (INPUT RowErrors.errorDescription).                
        END. 
        RETURN "NOK".
    END.
    
    RETURN "OK".
END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

