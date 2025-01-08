CREATE WIDGET-POOL.

DEFINE NEW GLOBAL SHARED VARIABLE v-log-emb-cc0311-portal AS LOG NO-UNDO.
DEFINE VARIABLE raw-param   AS RAW         NO-UNDO.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>ev049717-948288-948291-948295-948298-948</NumeroOperacao>   */
/*     <CodigoMensagem>MSG0205</CodigoMensagem>                                    */
/*     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0205>                                                                   */
/*       <DataPedido>2015-06-26</DataPedido>                                       */
/*       <MatriculaComprador>ev049717</MatriculaComprador>                         */
/*       <CodigoMensagemPedido>45</CodigoMensagemPedido>                           */
/*       <GerarProcessoImportacao>true</GerarProcessoImportacao>                   */
/*       <GerarEmbarque>true</GerarEmbarque>                                       */
/*       <TipoFrete>2</TipoFrete>                                                  */
/*       <OrdensCompra>                                                            */
/*         <NumeroOrdemCompra>948288</NumeroOrdemCompra>                           */
/*       </OrdensCompra>                                                           */
/*       <OrdensCompra>                                                            */
/*         <NumeroOrdemCompra>948291</NumeroOrdemCompra>                           */
/*       </OrdensCompra>                                                           */
/*       <OrdensCompra>                                                            */
/*         <NumeroOrdemCompra>948295</NumeroOrdemCompra>                           */
/*       </OrdensCompra>                                                           */
/*       <OrdensCompra>                                                            */
/*         <NumeroOrdemCompra>948298</NumeroOrdemCompra>                           */
/*       </OrdensCompra>                                                           */
/*       <OrdensCompra>                                                            */
/*         <NumeroOrdemCompra>948299</NumeroOrdemCompra>                           */
/*       </OrdensCompra>                                                           */
/*     </MSG0205>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0205.i}
/* Definiá∆o da Temp-Table "tt-erros-geral" */
{cdp/cdapi300.i1}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0205, MSG0205OrdensCompra
   DATA-RELATION FOR conteudo, MSG0205                   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0205, MSG0205OrdensCompra RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0205R1, MSG_Pedido_R1, resultado
   DATA-RELATION FOR conteudor, MSG0205R1     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0205R1, MSG_Pedido_R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0205R1, resultado     RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0205R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0205 NO-ERROR.

CREATE conteudor.
CREATE MSG0205R1.
CREATE resultado.

RUN pi-gera-pedido.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-gera-pedido:

    DEFINE VARIABLE de-indice AS DECIMAL     NO-UNDO.

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:

        /* Valida informaá‰es do pedido */
        FIND FIRST usuar-mater NO-LOCK
             WHERE usuar-mater.cod-usuario = MSG0205.MatriculaComprador
               AND usuar-mater.usuar-comprado NO-ERROR.

        IF NOT AVAILABLE usuar-mater THEN DO:
            RUN utp/ut-msgs.p (INPUT "MSG":U,
                               INPUT 2,
                               INPUT "Respons†vel":U).

            RUN pi-erro (INPUT RETURN-VALUE).
        END.

        FIND FIRST mensagem NO-LOCK 
             WHERE mensagem.cod-mensagem = MSG0205.CodigoMensagem NO-ERROR.

        IF NOT AVAILABLE mensagem THEN DO:
            RUN utp/ut-msgs.p (INPUT "MSG":U,
                               INPUT 2,
                               INPUT "Mensagem":U).

            RUN pi-erro (INPUT RETURN-VALUE).
        END.
        
        IF CAN-FIND (FIRST tt-erro) THEN DO:
            UNDO blk_principal, LEAVE blk_principal.
        END.

        EMPTY TEMP-TABLE tt-digita.
        FOR EACH MSG0205OrdensCompra:
            /*Geraá∆o do pedido*/
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = MSG0205OrdensCompra.NumeroOrdemCompra NO-ERROR.

            IF NOT AVAIL ordem-compra THEN DO:
                RUN pi-erro (INPUT "Ordem de compra n∆o cadastrada.":U).
                UNDO blk_principal, LEAVE blk_principal.
            END.

            IF ordem-compra.num-pedido <> 0 THEN DO:
                RUN pi-erro (INPUT "Ordem de compra " + STRING(ordem-compra.numero-ordem) + " j† possui pedido.":U).
                UNDO blk_principal, LEAVE blk_principal.
            END.

            /*Cota automaticamente as ordens "Em Cotaá∆o"*/
            IF ordem-compra.situacao = 5 THEN DO:
                RUN pi-cota-ordem.
                IF RETURN-VALUE <> "OK" THEN
                    UNDO blk_principal, LEAVE blk_principal.
            END.

            IF  ordem-compra.situacao      = 3
            AND ordem-compra.num-pedido    = 0
            AND ordem-compra.cod-cond-pag <> ?
            AND ordem-compra.expectativa   = NO THEN DO:

                FIND FIRST tt-digita
                     WHERE tt-digita.numero-ordem = ordem-compra.numero-ordem NO-ERROR.
    
                IF NOT AVAILABLE tt-digita THEN DO:
                    CREATE tt-digita.
                    ASSIGN tt-digita.marca        = "*":U
                           tt-digita.numero-ordem = ordem-compra.numero-ordem
                           tt-digita.it-codigo    = ordem-compra.it-codigo
                           tt-digita.cod-emitente = ordem-compra.cod-emitente
                           tt-digita.cod-estabel  = ordem-compra.cod-estabel
                           tt-digita.cod-comprado = ordem-compra.cod-comprado
                           tt-digita.nr-processo  = ordem-compra.nr-processo
                           tt-digita.num-pedido   = ordem-compra.num-pedido
                           tt-digita.natureza     = ordem-compra.natureza
                           tt-digita.cod-transp   = ordem-compra.cod-transp
                           tt-digita.data-cotacao = ordem-compra.data-cotacao
                           tt-digita.cod-cond-pag = ordem-compra.cod-cond-pag.
                END.
            END.
        END.

        IF NOT CAN-FIND(FIRST tt-digita) THEN DO:
            RUN pi-erro (INPUT "N∆o foram encontradas Ordens de Compra para geraá∆o de Pedido.":U).
            UNDO blk_principal, LEAVE blk_principal.
        END.

        EMPTY TEMP-TABLE tt-param.

        CREATE tt-param.
        ASSIGN tt-param.usuario   = c-seg-usuario
               tt-param.destino   = 3
               tt-param.data-exec = TODAY
               tt-param.hora-exec = TIME.

        /*Cria faixas na tt-pram com base na tt-digita*/
        FOR FIRST tt-digita
            BY tt-digita.cod-emitente:
            ASSIGN tt-param.i-forn-ini = tt-digita.cod-emitente.
        END.

        FOR LAST tt-digita
            BY tt-digita.cod-emitente:
            ASSIGN tt-param.i-forn-fim = tt-digita.cod-emitente.
        END.

        FOR FIRST tt-digita
            BY tt-digita.cod-estabel:
            ASSIGN tt-param.c-estabel-ini = tt-digita.cod-estabel.
        END.

        FOR LAST tt-digita
            BY tt-digita.cod-estabel:
            ASSIGN tt-param.c-estabel-fim = tt-digita.cod-estabel.
        END.

        FOR FIRST tt-digita
            BY tt-digita.nr-processo:
            ASSIGN tt-param.i-processo-ini = tt-digita.nr-processo.
        END.

        FOR LAST tt-digita
            BY tt-digita.nr-processo:
            ASSIGN tt-param.i-processo-fim = tt-digita.nr-processo.
        END.

        FOR FIRST tt-digita
            BY tt-digita.numero-ordem:
            ASSIGN tt-param.i-ord-ini = tt-digita.numero-ordem.
        END.

        FOR LAST tt-digita
            BY tt-digita.numero-ordem:
            ASSIGN tt-param.i-ord-fim = tt-digita.numero-ordem.
        END.

        FOR FIRST tt-digita
            BY tt-digita.data-cotacao:
            ASSIGN tt-param.da-cot-ini = tt-digita.data-cotacao.
        END.

        FOR LAST tt-digita
            BY tt-digita.data-cotacao:
            ASSIGN tt-param.da-cot-fim = tt-digita.data-cotacao.
        END.

        FOR FIRST tt-digita
            BY tt-digita.it-codigo:
            ASSIGN tt-param.c-it-ini = tt-digita.it-codigo.
        END.

        FOR LAST tt-digita
            BY tt-digita.it-codigo:
            ASSIGN tt-param.c-it-fim = tt-digita.it-codigo.
        END.

        FOR FIRST tt-digita
            BY tt-digita.cod-comprado:
            ASSIGN tt-param.c-comp-ini = tt-digita.cod-comprado.
        END.

        FOR LAST tt-digita
            BY tt-digita.cod-comprado:
            ASSIGN tt-param.c-comp-fim = tt-digita.cod-comprado.
        END.

        ASSIGN tt-param.i-nr-ordem      = 9999
               tt-param.da-data-ped     = MSG0205.DataPedido
               tt-param.c-est-cob       = ordem-compra.cod-estabel
               tt-param.c-estab         = IF AVAILABLE estabelec THEN estabelec.nome ELSE ""
               tt-param.c-resp          = MSG0205.MatriculaComprador
               tt-param.c-deresp        = IF AVAILABLE usuar_mestre THEN usuar_mestre.nom_usuario ELSE ""
               tt-param.i-cod-mens      = MSG0205.CodigoMensagem
               tt-param.c-msg           = IF AVAILABLE mensagem THEN mensagem.descricao ELSE ""
               tt-param.i-condicao      = 1
               &IF DEFINED(bf_mat_contratos) &THEN
               tt-param.c-estab-gestor  = ordem-compra.cod-estabel
               &ELSE
               tt-param.c-estab-gestor  = "":U
               &ENDIF
               tt-param.i-frete         = MSG0205.TipoFrete /*1 - Pago   2 - A Pagar*/
               tt-param.c-frete         = IF MSG0205.TipoFrete = 1 THEN "Pago" ELSE "A Pagar"
               tt-param.l-importacao    = MSG0205.GerarProcessoImportacao.

        &IF DEFINED(bf_mat_oper_triangular) &THEN
        ASSIGN tt-param.i-cod-emit-terc = 0.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = tt-param.i-cod-emit-terc NO-ERROR.

        ASSIGN tt-param.c-nome-abrev = IF AVAILABLE emitente THEN emitente.nome-abrev ELSE "":U.
        &ELSE
        ASSIGN tt-param.i-cod-emit-terc = "":U
               tt-param.c-nome-abrev    = "":U.
        &ENDIF

        FIND FIRST cond-pagto NO-LOCK 
             WHERE cond-pagto.cod-cond-pag = tt-param.i-condicao NO-ERROR.

        ASSIGN tt-param.c-pagto   = IF AVAILABLE cond-pagto THEN cond-pagto.descricao ELSE "":U
               tt-param.c-destino = "Arquivo":U
               tt-param.arquivo   = SESSION:TEMP-DIRECTORY + "portal_pedido" + ".tmp":U.

        IF MSG0205.GerarEmbarque THEN
            ASSIGN v-log-emb-cc0311-portal = YES.
        ELSE 
            ASSIGN v-log-emb-cc0311-portal = NO.

        RAW-TRANSFER tt-param TO raw-param.

        EMPTY TEMP-TABLE tt-raw-digita.

        FOR EACH tt-digita:
            CREATE tt-raw-digita.
            RAW-TRANSFER tt-digita TO tt-raw-digita.raw-digita.
        END.

        RUN ccp/cc0311rp.p (INPUT raw-param,
                            INPUT TABLE tt-raw-digita).

        IF RETURN-VALUE = "OK" THEN DO:
            
            FOR EACH tt-digita:
                FIND FIRST ordem-compra NO-LOCK
                     WHERE ordem-compra.cod-emitente = tt-digita.cod-emitente
                       AND ordem-compra.numero-ordem = tt-digita.numero-ordem NO-ERROR.
                IF NOT CAN-FIND (FIRST MSG_Pedido_R1
                                 WHERE MSG_Pedido_R1.NumeroPedido = ordem-compra.num-pedido) THEN DO:

                    /*Marca os pedido gerados como impresso*/
                    FIND FIRST pedido-compr EXCLUSIVE-LOCK
                         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

                    IF  AVAIL pedido-compr
                    AND pedido-compr.situacao <> 1 /*Impresso*/ THEN 
                        ASSIGN pedido-compr.situacao = 1.

                    FIND FIRST int-pedido-compr EXCLUSIVE-LOCK
                         WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-ERROR.

                    IF NOT AVAIL int-pedido-compr THEN DO:
                        /*Cria extená∆o do pedido*/
                        CREATE int-pedido-compr.
                        ASSIGN int-pedido-compr.num-pedido = pedido-compr.num-pedido.
                    END.

                    ASSIGN int-pedido-compr.tp-pedido            = 2 /*autom†tico*/
                           int-pedido-compr.SituacaoAceitePedido = 1. /*emitido*/

                    FIND FIRST emitente NO-LOCK 
                        WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.
                        
                    RELEASE pedido-compr.
                    RELEASE int-pedido-compr.

                    CREATE MSG_Pedido_R1.
                    ASSIGN MSG_Pedido_R1.NumeroPedidoCompra      = ordem-compra.num-pedido
                           MSG_Pedido_R1.CodigoFornecedorEMS     = IF AVAIL emitente THEN emitente.cod-emitente ELSE ?
                           MSG_Pedido_R1.NomeAbreviadoFornecedor = IF AVAIL emitente THEN emitente.nome-abrev   ELSE ?.
                END.
            END.
        END.

        RELEASE ordem-compra.
        RELEASE cotacao-item.
        RELEASE prazo-compra.

    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cota-ordem:

    /*Considera fornecedor da primeira cotaá∆o parametrizado no cc0531 (data <> 11/11/1111)*/
    FIND FIRST cotacao-item NO-LOCK 
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
           AND cotacao-item.data-cotacao <> 11/11/1111 NO-ERROR.

    IF NOT AVAILABLE cotacao-item THEN DO:
        RUN pi-erro (INPUT "N∆o foi encontrado nenhuma cotaá∆o para ordem " + STRING(ordem-compra.numero-ordem)).
        RETURN "NOK".
    END.

    IF cotacao-item.preco-unit = 0 THEN DO:
        RUN pi-erro (INPUT "Ordem Compra: ":U + TRIM(STRING(ordem-compra.numero-ordem, "zzzzz9,99":U)) + " com situaá∆o 'Em Cotaá∆o' possui preáo 0 (zero).").
        RETURN "NOK".
    END. 

    RUN ccp/ccapi340.p (INPUT cotacao-item.cod-emitente,
                        INPUT cotacao-item.numero-ordem,
                        INPUT cotacao-item.it-codigo,
                        INPUT cotacao-item.seq-cotac,
                        OUTPUT TABLE tt-erros-geral).

    IF CAN-FIND(FIRST tt-erros-geral) THEN DO:
        FOR EACH tt-erros-geral:
            RUN pi-erro (INPUT tt-erros-geral.des-erro).
        END.

        RETURN "NOK".
    END.
    
    FIND CURRENT ordem-compra EXCLUSIVE-LOCK.

    ASSIGN ordem-compra.situacao = 3. /* Cotada */

    FOR EACH prazo-compra EXCLUSIVE-LOCK
        WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
        ASSIGN prazo-compra.situacao = ordem-compra.situacao.
    END.
    
    FIND CURRENT ordem-compra NO-LOCK.

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
