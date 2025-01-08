CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/*  DEFINE VARIABLE /*INPUT  PARAMETER*/ iXML AS LONGCHAR NO-UNDO. */
/* DEFINE VARIABLE /*OUTPUT PARAMETER*/ oXML AS LONGCHAR NO-UNDO.  */
DEFINE VARIABLE i AS INTEGER     NO-UNDO.

 ASSIGN i = ETIME.

/* ASSIGN iXML = '<?xml version="1.0" encoding="UTF-8"?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>105-MA054397-161953</NumeroOperacao>                        */
/*     <CodigoMensagem>MSG0226</CodigoMensagem>                                    */
/*     <LoginUsuario>fr049656</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0226>                                                                   */
/*       <MatriculaComprador>MA054397</MatriculaComprador>                         */
/*       <StatusEmbarque>1</StatusEmbarque>                                        */
/*       <EmbarquesDisponiveis>true</EmbarquesDisponiveis>                         */
/*       <CodigoIncoterm>FOB</CodigoIncoterm>                                      */
/*       <CodigoItinerario>322</CodigoItinerario>                                  */
/*       <CodigoEstabelecimento>105</CodigoEstabelecimento>                        */
/*       <CodigoFornecedorEMS>161953</CodigoFornecedorEMS>                         */
/*       <MatriculaUsuario>fr049656</MatriculaUsuario>                             */
/*     </MSG0226>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>'.                                                                   */

/* */
{esp/esb/in/msg0226.i}
{esp/es0018.i}
{esp/esb/esesb000fn1.i}
/**/
DEFINE VARIABLE h-bocx220         AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-valor-embarque AS DECIMAL DECIMALS 4    NO-UNDO.
DEFINE VARIABLE i-mo-codigo       LIKE moeda.mo-codigo.
DEFINE VARIABLE v-cod-cond-pag    AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-unit           AS DECIMAL DECIMALS 4    NO-UNDO.

DEFINE BUFFER b1-historico-embarque    FOR historico-embarque.
DEFINE BUFFER b2-historico-embarque    FOR historico-embarque.
DEFINE BUFFER b3-historico-embarque    FOR historico-embarque.
DEFINE BUFFER b-ordem-compra           FOR ordem-compra.
DEFINE BUFFER b1-ordem-compra          FOR ordem-compra.
DEFINE BUFFER b2-ordem-compra          FOR ordem-compra.
DEFINE BUFFER b-emitente               FOR emitente.
DEFINE BUFFER b-aux-historico-embarque FOR historico-embarque.
DEFINE BUFFER b-aux-pto-contr          FOR pto-contr.
DEFINE BUFFER b-ordens-embarque        FOR ordens-embarque.
DEFINE BUFFER b-cotacao-item           FOR cotacao-item.
DEFINE QUERY qr-chave-embaque
    FOR embarque-imp, ordens-embarque, ordem-compra, cotacao-item.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0226
   DATA-RELATION FOR conteudo, MSG0226 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0226R1, Embarque_R1, Resultado
   DATA-RELATION FOR conteudor, MSG0226R1   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0226R1, Embarque_R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0226R1, resultado   RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0226R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0226 NO-ERROR.

CREATE conteudor.
CREATE MSG0226R1.
CREATE Resultado.


RUN pi-gera-embarques.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO). 

/* DEFINE VARIABLE hDoc AS HANDLE   NO-UNDO.                                                    */
/* CREATE X-DOCUMENT hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-gera-embarques:

    ASSIGN MSG0226R1.ExibePrecos = fnExibePrecos(MSG0226.MatriculaUsuario).

    /*para encerrados e todos obriga faixa m†xima de 6 meses*/
    IF MSG0226.StatusEmbarque <> 1 THEN DO:
        IF  MSG0226.DataFinalChegada   = ?
        OR  MSG0226.DataInicialChegada = ? THEN  DO:
            RUN pi-erro (INPUT "Para embarques em andamento, informe faixa de data de no m†ximo 6 meses.").
            RETURN "NOK".
        END.

        
        IF ROUND((MSG0226.DataFinalChegada - MSG0226.DataInicialChegada) / 30,0) > 6 THEN DO:
            RUN pi-erro (INPUT "Para embarques em andamento, faixa m†xima de data permitida Ç 6 meses.").
            RETURN "NOK".
        END.
    END.

    /*Ao menos um dos filtros abaixo Ç obrigat¢rio*/
    IF MSG0226.EmbarquesDisponiveis THEN DO:
        FOR EACH embarque-imp NO-LOCK USE-INDEX situacao
           WHERE embarque-imp.situacao    = 1
             AND embarque-imp.cod-estabel = MSG0226.CodigoEstabelecimento,
            EACH ordens-embarque OF embarque-imp NO-LOCK,
            EACH ordem-compra OF ordens-embarque NO-LOCK,
           FIRST cotacao-item NO-LOCK
           WHERE cotacao-item.numero-ordem            = ordem-compra.numero-ordem
             AND cotacao-item.cod-emitente            = MSG0226.CodigoFornecedorEMS
             AND cotacao-item.int-1                   = MSG0226.CodigoItinerario
             AND SUBSTRING(cotacao-item.char-1,21,3)  = MSG0226.CodigoIncoterm
             AND cotacao-item.cot-aprovada:

            RUN gera-retorno.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".    
        END.
    END.
    ELSE IF MSG0226.NumeroEmbarque <> ? THEN DO:

        /*feito uma query para usar o OUTER-JOIN*/
        OPEN QUERY qr-chave-embaque
        FOR EACH embarque-imp NO-LOCK
           WHERE embarque-imp.cod-estabel = MSG0226.CodigoEstabelecimento
             AND embarque-imp.embarque    = MSG0226.NumeroEmbarque,
            EACH ordens-embarque OF embarque-imp    NO-LOCK OUTER-JOIN,
           FIRST ordem-compra    OF ordens-embarque NO-LOCK OUTER-JOIN,
           FIRST cotacao-item    NO-LOCK OUTER-JOIN
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
             AND cotacao-item.cod-emitente = ordem-compra.cod-emitente.

        blk_repeat:
        REPEAT:
            GET NEXT qr-chave-embaque.
            IF NOT AVAIL embarque-imp THEN
                LEAVE blk_repeat.
                          
            RUN gera-retorno.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END.
    ELSE IF MSG0226.CodigoFornecedorEMS <> ? THEN DO:
        FOR EACH ordem-compra NO-LOCK
           WHERE ordem-compra.cod-emitente = MSG0226.CodigoFornecedorEMS,
           FIRST cotacao-item NO-LOCK 
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
             AND cotacao-item.cod-emitente = ordem-compra.cod-emitente,
            EACH ordens-embarque OF ordem-compra    NO-LOCK,
           FIRST embarque-imp    OF ordens-embarque NO-LOCK:

            RUN gera-retorno.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END.
    ELSE IF MSG0226.MatriculaComprador <> ? THEN DO:

        FOR EACH ordem-compra NO-LOCK
           WHERE ordem-compra.cod-comprado = MSG0226.MatriculaComprador,
           FIRST cotacao-item    NO-LOCK
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
             AND cotacao-item.cod-emitente = ordem-compra.cod-emitente,
            EACH ordens-embarque OF ordem-compra    NO-LOCK,
           FIRST embarque-imp    OF ordens-embarque NO-LOCK:
            
            RUN gera-retorno.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END.
    ELSE IF MSG0226.NumeroPedidoCompra <> ? THEN DO:
        FOR EACH ordem-compra NO-LOCK
           WHERE ordem-compra.num-pedido = MSG0226.NumeroPedidoCompra,
           FIRST cotacao-item    NO-LOCK
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
             AND cotacao-item.cod-emitente = ordem-compra.cod-emitente,
            EACH ordens-embarque OF ordem-compra    NO-LOCK,
           FIRST embarque-imp    OF ordens-embarque NO-LOCK:

            RUN gera-retorno.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END.
    ELSE IF MSG0226.CodigoDespachante     <> ? 
        AND MSG0226.CodigoEstabelecimento <> ?
        AND MSG0226.StatusEmbarque         = 1 THEN DO: 

        FOR EACH embarque-imp NO-LOCK
           WHERE embarque-imp.cod-estabel     = MSG0226.CodigoEstabelecimento
             AND embarque-imp.cod-despachante = MSG0226.CodigoDespachante
             AND embarque-imp.situacao        = 1,
            EACH ordens-embarque OF embarque-imp NO-LOCK,
            EACH ordem-compra OF ordens-embarque NO-LOCK,
           FIRST cotacao-item NO-LOCK
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
             AND cotacao-item.cod-emitente = ordem-compra.cod-emitente:

            RUN gera-retorno.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".

        END.
    END.
    ELSE IF MSG0226.CodigoDespachante     <> ? 
        AND MSG0226.CodigoEstabelecimento <> ? THEN DO: 

        FOR EACH embarque-imp NO-LOCK
           WHERE embarque-imp.cod-estabel     = MSG0226.CodigoEstabelecimento
             AND embarque-imp.cod-despachante = MSG0226.CodigoDespachante:

            FIND FIRST historico-embarque NO-LOCK
                 WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                   AND historico-embarque.embarque      = embarque-imp.embarque NO-ERROR.

            /*Ponto de Chegada*/ 
            FIND FIRST b2-historico-embarque NO-LOCK
                 WHERE b2-historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                   AND b2-historico-embarque.embarque      = embarque-imp.embarque
                   AND b2-historico-embarque.cod-itiner    = historico-embarque.cod-itiner
                   AND b2-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad NO-ERROR.
            
            IF  MSG0226.DataInicialChegada <> ? 
            AND MSG0226.DataFinalChegada   <> ? 
            AND AVAIL b2-historico-embarque THEN DO: 
            
                 IF b2-historico-embarque.dt-efetiva <> ? THEN DO:
                     IF b2-historico-embarque.dt-efetiva > MSG0226.DataFinalChegada
                     OR b2-historico-embarque.dt-efetiva < MSG0226.DataInicialChegada THEN
                         NEXT.
                 END.
                 ELSE DO:
                     IF b2-historico-embarque.dt-ult-previsao > MSG0226.DataFinalChegada
                     OR b2-historico-embarque.dt-ult-previsao < MSG0226.DataInicialChegada THEN
                         NEXT.
                 END.
            END.

            FOR EACH ordens-embarque OF embarque-imp NO-LOCK,
                EACH ordem-compra OF ordens-embarque NO-LOCK,
               FIRST cotacao-item NO-LOCK
               WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                 AND cotacao-item.cod-emitente = ordem-compra.cod-emitente:
            
                FIND FIRST estabelec NO-LOCK
                     WHERE estabelec.cod-estabel = ordens-embarque.cod-estabel NO-ERROR.
            
                FIND FIRST itinerario NO-LOCK
                     WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.
            
                
            
                RUN gera-retorno.
                IF RETURN-VALUE <> "OK" THEN
                    RETURN "NOK".
            END.

        END.
    END.
    ELSE IF MSG0226.CodigoEstabelecimento <> ? THEN DO:

        FOR EACH ordem-compra NO-LOCK
           WHERE ordem-compra.cod-estabel = MSG0226.CodigoEstabelecimento,
           FIRST cotacao-item NO-LOCK
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
             AND cotacao-item.cod-emitente = ordem-compra.cod-emitente,
            EACH ordens-embarque OF ordem-compra    NO-LOCK,
           FIRST embarque-imp    OF ordens-embarque NO-LOCK:

            RUN gera-retorno.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END.
    ELSE DO:
        RUN pi-erro (INPUT "Ao menos um dos seguintes filtros deve ser informado: Embarques Dispon°veis, N£mero do Embarque, C¢digo do Fornecedor, Matricula do Comprador ou N£mero do Pedido de Compra").
    END.

    RETURN "OK".
END PROCEDURE.

PROCEDURE gera-retorno:
    
    blk-retorno:
    DO TRANSACTION
    ON ERROR UNDO blk-retorno, LEAVE blk-retorno
    ON STOP  UNDO blk-retorno, LEAVE blk-retorno:       

        /*Controle para n∆o criar duas vezes o mesmo embarque*/
        FIND FIRST tt-embarques-lidos
             WHERE tt-embarques-lidos.embarque = ordens-embarque.embarque NO-ERROR.
        
        IF NOT AVAIL tt-embarques-lidos THEN DO:
    
            RUN pi-situacao.

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = cotacao-item.cod-emitente NO-ERROR.
    
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = ordens-embarque.cod-estabel NO-ERROR.
    
            FIND FIRST itinerario NO-LOCK
                 WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.

            /*Ponto de Embarque*/
            FIND FIRST b1-historico-embarque NO-LOCK
                 WHERE b1-historico-embarque.cod-estabel   = estabelec.cod-estabel
                   AND b1-historico-embarque.embarque      = ordens-embarque.embarque
                   AND b1-historico-embarque.cod-itiner    = itinerario.cod-itiner
                   AND b1-historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.

            /*Ponto de Chegada*/ 
            FIND FIRST b2-historico-embarque NO-LOCK
                 WHERE b2-historico-embarque.cod-estabel   = estabelec.cod-estabel
                   AND b2-historico-embarque.embarque      = ordens-embarque.embarque
                   AND b2-historico-embarque.cod-itiner    = itinerario.cod-itiner
                   AND b2-historico-embarque.cod-pto-contr = itinerario.pto-chegada NO-ERROR.

            FIND FIRST b3-historico-embarque NO-LOCK
                 WHERE b3-historico-embarque.cod-estabel = estabelec.cod-estabel
                   AND b3-historico-embarque.embarque    = ordens-embarque.embarque
                   AND b3-historico-embarque.cod-itiner  = itinerario.cod-itiner
                   AND b3-historico-embarque.dt-efetiva  = ?  NO-ERROR.

            RUN pi-aplica-outros-filtros.
            
            IF RETURN-VALUE <> "OK" THEN
                RETURN "OK".

            CREATE tt-embarques-lidos.
            ASSIGN tt-embarques-lidos.embarque = ordens-embarque.embarque.
    
            /*Ultimo Ponto de controle efetivado*/
            RELEASE historico-embarque.
            FOR LAST historico-embarque NO-LOCK
               WHERE historico-embarque.cod-estabel = estabelec.cod-estabel
                 AND historico-embarque.embarque    = ordens-embarque.embarque
                 AND historico-embarque.cod-itiner  = itinerario.cod-itiner
                 AND historico-embarque.dt-efetiva <> ?
               BREAK BY historico-embarque.dt-efetiva:
            END.
    
            RELEASE pto-contr.
            IF AVAIL historico-embarque THEN DO:
                FIND FIRST pto-contr NO-LOCK
                     WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.
            END.
    
            
            /* Pr¢ximo Ponto de controle n∆o efetivado a partir do £ltimo efetivado */
            RELEASE b-aux-historico-embarque.
            IF  AVAIL historico-embarque THEN DO:
                
                FOR FIRST b-aux-historico-embarque NO-LOCK
                   WHERE b-aux-historico-embarque.cod-estabel = historico-embarque.cod-estabel
                     AND b-aux-historico-embarque.embarque    = historico-embarque.embarque
                     AND b-aux-historico-embarque.cod-itiner  = historico-embarque.cod-itiner
                     AND b-aux-historico-embarque.dt-efetiva  = ?
                     AND b-aux-historico-embarque.sequencia   > historico-embarque.sequencia
                   BREAK BY b-aux-historico-embarque.sequencia:
                END.
        
                RELEASE b-aux-pto-contr.
                IF AVAIL b-aux-historico-embarque THEN DO:
                    FIND FIRST b-aux-pto-contr NO-LOCK
                         WHERE b-aux-pto-contr.cod-pto-contr = b-aux-historico-embarque.cod-pto-contr NO-ERROR.
                END.
            END.
            ELSE DO:
                FOR FIRST b-aux-historico-embarque NO-LOCK
                   WHERE b-aux-historico-embarque.cod-estabel = estabelec.cod-estabel
                     AND b-aux-historico-embarque.embarque    = ordens-embarque.embarque
                     AND b-aux-historico-embarque.cod-itiner  = itinerario.cod-itiner
                     AND b-aux-historico-embarque.dt-efetiva  = ?
                   BREAK BY b-aux-historico-embarque.sequencia:
                END.
        
                RELEASE b-aux-pto-contr.
                IF AVAIL b-aux-historico-embarque THEN DO:
                    FIND FIRST b-aux-pto-contr NO-LOCK
                         WHERE b-aux-pto-contr.cod-pto-contr = b-aux-historico-embarque.cod-pto-contr NO-ERROR.
                END.
            END.


            FIND FIRST inco-cx NO-LOCK
                 WHERE inco-cx.cod-incoterm = embarque-imp.cod-incoterm NO-ERROR.

            IF NOT VALID-HANDLE(h-bocx220) THEN
                RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

            RUN retornaMoedaValor IN h-bocx220 (INPUT  embarque-imp.embarque,
                                                INPUT  embarque-imp.cod-estabel,
                                                OUTPUT de-valor-embarque,
                                                OUTPUT i-mo-codigo).

            /*Desconta valor das parcelas FOC*/
            FOR EACH b-ordens-embarque OF embarque-imp NO-LOCK,
               FIRST b2-ordem-compra OF b-ordens-embarque 
               WHERE b2-ordem-compra.cod-cond-pag = 63 NO-LOCK:
                FIND FIRST b-cotacao-item
                     WHERE b-cotacao-item.numero-ordem = b2-ordem-compra.numero-ordem
                       AND b-cotacao-item.it-codigo    = b2-ordem-compra.it-codigo
                       AND b-cotacao-item.cod-emitente = b2-ordem-compra.cod-emitente
                       AND b-cotacao-item.cot-aprovada = yes no-lock no-error.

                ASSIGN de-unit = 0.
                IF AVAIL b-cotacao-item THEN
                    ASSIGN de-unit = (b-cotacao-item.pre-unit-for * 100) / (100 + b-cotacao-item.aliquota-ipi).

                ASSIGN de-valor-embarque = de-valor-embarque - (b-ordens-embarque.qt-do-forn * de-unit).
            END.

            DELETE PROCEDURE h-bocx220.
            ASSIGN h-bocx220 = ?.

            FIND FIRST moeda NO-LOCK
                 WHERE moeda.mo-codigo = i-mo-codigo NO-ERROR.

            RUN esp/es0018p.p (INPUT "CondPagEmbar":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            ASSIGN v-cod-cond-pag = ?.
            blk_cond_pag:
            FOR EACH b-ordens-embarque OF embarque-imp NO-LOCK,
                EACH b2-ordem-compra OF b-ordens-embarque 
               WHERE b2-ordem-compra.cod-cond-pag <> 63 NO-LOCK:
                /*N∆o considera as condiá‰es de pagamento deste ponto*/
                IF NOT CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = string(b2-ordem-compra.cod-cond-pag)) THEN DO:
                    ASSIGN v-cod-cond-pag = b2-ordem-compra.cod-cond-pag.
                    LEAVE blk_cond_pag.
                END.
            END.

            IF v-cod-cond-pag = ? THEN
                ASSIGN v-cod-cond-pag = ordem-compra.cod-cond-pag.

            FIND FIRST cond-pagto NO-LOCK
                 WHERE cond-pagto.cod-cond-pag = v-cod-cond-pag NO-ERROR.

            FIND FIRST processo-imp NO-LOCK
                 WHERE processo-imp.num-pedido = ordem-compra.num-pedido NO-ERROR.

            FIND FIRST pedido-compr NO-LOCK
                 WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

            FIND FIRST int-processo-imp NO-LOCK
                 WHERE int-processo-imp.cod-estabel = processo-imp.cod-estabel
                   AND int-processo-imp.nr-proc-imp = processo-imp.nr-proc-imp NO-ERROR.

            FIND FIRST ext-embarque-imp NO-LOCK
                 WHERE ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
                   AND ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.

            FIND FIRST b-emitente NO-LOCK
                 WHERE b-emitente.cod-emitente = embarque-imp.cod-despachante NO-ERROR.
    
            CREATE Embarque_R1.
            ASSIGN Embarque_R1.NumeroEmbarque                 = embarque-imp.embarque
                   Embarque_R1.CodigoEstabelecimento          = embarque-imp.cod-estabel                      
                   Embarque_R1.CodigoIncoterm                 = embarque-imp.cod-incoterm
                   Embarque_R1.DescricaoIncoterm              = IF AVAIL inco-cx      THEN inco-cx.descricao         ELSE ""
                   Embarque_R1.CodigoItinerario               = IF AVAIL cotacao-item THEN cotacao-item.int-1        ELSE ?                            
                   Embarque_R1.DescricaoItinerario            = IF AVAIL itinerario   THEN itinerario.descricao      ELSE ""
                   Embarque_R1.CodigoFornecedorEMS            = IF AVAIL cotacao-item THEN cotacao-item.cod-emitente ELSE ?  
                   Embarque_R1.NomeAbreviadoFornecedor        = IF AVAIL emitente     THEN emitente.nome-abrev       ELSE ""
                   Embarque_R1.SituacaoEmbarque               = IF AVAIL tt-emb       THEN tt-emb.situacao           ELSE 1
                   Embarque_R1.DescricaoUltimoPontoControle   = IF AVAIL pto-contr    THEN pto-contr.descricao       ELSE ""
                   Embarque_R1.DataEfetivaUltimoPontoControle = IF AVAIL historico-embarque THEN historico-embarque.dt-efetiva ELSE ?
                   Embarque_R1.Atrasado                       = IF AVAIL b3-historico-embarque THEN
                                                                    IF b3-historico-embarque.dt-ult-prev >= TODAY THEN NO ELSE YES
                                                                ELSE
                                                                    NO
                   Embarque_R1.ValorEmbarque                  = de-valor-embarque   
                   Embarque_R1.CodigoMoedaEMS                 = IF AVAIL moeda      THEN moeda.mo-codigo         ELSE ?
                   Embarque_R1.NomeMoeda                      = IF AVAIL moeda      THEN moeda.descricao         ELSE ?     
                   Embarque_R1.CodigoCondicaoPagamento        = IF AVAIL cond-pagto THEN cond-pagto.cod-cond-pag ELSE ?    
                   Embarque_R1.NomeCondicaoPagamento          = IF AVAIL cond-pagto THEN cond-pagto.descricao    ELSE ?     
                   Embarque_R1.NivelCriticidade               = IF AVAIL int-criticidade-item THEN int-criticidade-item.nivel-criticidade ELSE ?
                   Embarque_R1.CodigoViaTransporte            = embarque-imp.cod-via-transp /*{adinc/i01ad268.i 04 embarque-imp.cod-via-transp}*/ 
                   Embarque_R1.StatusEmbarque                 = embarque-imp.situacao
                   Embarque_R1.NomeDestino                    = IF AVAIL int-processo-imp THEN int-processo-imp.NomeDestino ELSE ""
                   Embarque_R1.TipoContainer                  = IF AVAIL ext-embarque-imp AND ext-embarque-imp.conteiner <> 0 THEN ext-embarque-imp.conteiner      ELSE ?
                   Embarque_R1.Quantidade1Container           = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.qtd-conteiner  ELSE ?
                   Embarque_R1.Quantidade2Container           = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.qtd2-conteiner ELSE ?
                   Embarque_R1.Master                         = embarque-imp.cod-conhecto-master
                   Embarque_R1.House                          = embarque-imp.cod-conhecto-house
                   Embarque_R1.VeiculoTransporte              = IF AVAIL historico-embarque THEN historico-embarque.id-meio-transp ELSE ?
                   Embarque_R1.CodigoDespachante              = IF AVAIL b-emitente THEN b-emitente.cod-emitente ELSE 0
                   Embarque_R1.NomeDespachante                = IF AVAIL b-emitente THEN b-emitente.nome-abrev   ELSE ""
                   Embarque_R1.DISiscomex                     = embarque-imp.declaracao-import
                   Embarque_R1.CodigoPrimPontoNaoEfet         = IF AVAIL b-aux-pto-contr  THEN b-aux-pto-contr.cod-pto-contr ELSE ?
                   Embarque_R1.DescricaoPrimePontoNaoEfet     = IF AVAIL b-aux-pto-contr  THEN b-aux-pto-contr.descricao ELSE ?
                   Embarque_R1.DtUltPrevPrimPontoNaoEfeto     = IF AVAIL b-aux-historico-embarque THEN b-aux-historico-embarque.dt-ult-previsao ELSE ?
                   Embarque_R1.VeicTranspPrimPontoNaoEfet     = IF AVAIL b-aux-historico-embarque THEN b-aux-historico-embarque.id-meio-transp  ELSE ?
                   Embarque_R1.SequenciaPontoControle         = IF AVAIL b-aux-historico-embarque THEN b-aux-historico-embarque.sequencia       ELSE ?
                   Embarque_R1.DataPrevOriginalPontoControle  = IF AVAIL b-aux-historico-embarque THEN b-aux-historico-embarque.dt-previsao     ELSE ?  
                   Embarque_R1.ObservacoesPontoControle       = IF AVAIL b-aux-historico-embarque THEN b-aux-historico-embarque.observacao      ELSE ?  
                       .

            FIND FIRST b1-ordem-compra OF ordens-embarque NO-LOCK NO-ERROR.

            blk_invoices:
            FOR EACH invoice-emb-imp OF embarque-imp NO-LOCK:
                FIND FIRST pagamento-invoice NO-LOCK
                     WHERE pagamento-invoice.embarque   = embarque-imp.embarque
                       AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice 
                       AND pagamento-invoice.parcela    = invoice-emb-imp.parcela NO-ERROR.

                IF AVAIL pagamento-invoice THEN DO:
                    ASSIGN Embarque_R1.PossuiCIPagamento = YES.

                    FIND FIRST pagamento NO-LOCK
                         WHERE pagamento.nr-pagamento = pagamento-invoice.nr-pagamento NO-ERROR.

                    IF  AVAIL pagamento
                    AND pagamento.recebido-ap THEN DO:
                        ASSIGN Embarque_R1.Recebida = YES.
                        LEAVE blk_invoices.
                    END.
                END.
            END.
            
            IF  AVAIL ext-embarque-imp 
            AND ext-embarque-imp.MatriculaResponsavel <> "" THEN DO:
                FIND FIRST usuar_mestre NO-LOCK
                     WHERE usuar_mestre.cod_usuario = ext-embarque-imp.MatriculaResponsavel NO-ERROR.

                ASSIGN Embarque_R1.MatriculaResponsavel = ext-embarque-imp.MatriculaResponsavel.
            END.    
            ELSE DO:
                FIND FIRST usuar_mestre NO-LOCK
                     WHERE usuar_mestre.cod_usuario = b1-ordem-compra.cod-comprado NO-ERROR.

                ASSIGN Embarque_R1.MatriculaResponsavel = IF AVAIL b1-ordem-compra THEN b1-ordem-compra.cod-comprado ELSE ?.
            END.

            ASSIGN Embarque_R1.NomeResponsavel = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ?.

            /*Ponto de Embarque*/
            IF AVAIL b1-historico-embarque THEN DO:
                IF b1-historico-embarque.dt-efetiva <> ? THEN
                    ASSIGN Embarque_R1.DataEfetivaEmbarque = b1-historico-embarque.dt-efetiva.
                ELSE 
                    ASSIGN Embarque_R1.DataPrevisaoEmbarque = b1-historico-embarque.dt-ult-previsao.
            END.
            ELSE 
                ASSIGN Embarque_R1.DataPrevisaoEmbarque = ?.
    
            /*Ponto de Chegada*/ 
            IF AVAIL b2-historico-embarque THEN DO:
                IF b2-historico-embarque.dt-efetiva <> ? THEN
                    ASSIGN Embarque_R1.DataPrevisaoChegada = b2-historico-embarque.dt-efetiva.
                ELSE 
                    ASSIGN Embarque_R1.DataPrevisaoChegada = b2-historico-embarque.dt-ult-previsao.
            END.
            ELSE 
                ASSIGN Embarque_R1.DataPrevisaoChegada = ?.
                

            /*chamado 83953 - incluir fixo o n£mero do ponto 396 - Entrega Documentos Originais - j† efetivado*/
            FOR FIRST b1-historico-embarque NO-LOCK
               WHERE b1-historico-embarque.cod-estabel   = estabelec.cod-estabel
                 AND b1-historico-embarque.embarque      = ordens-embarque.embarque
                 AND b1-historico-embarque.cod-itiner    = itinerario.cod-itiner
                 AND b1-historico-embarque.cod-pto-contr = 396
                 AND b1-historico-embarque.dt-efetiva  <> ?:
                 ASSIGN Embarque_R1.DocsOriginais = YES.
            END.
            
        END.
    END.

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-aplica-outros-filtros:

    IF  MSG0226.SomenteComCoberturaCambial 
    AND ordem-compra.cod-cond-pag = 63 THEN DO:
        RETURN "NOK".
    END.

    IF MSG0226.EmbarquesDisponiveis THEN DO:
        FOR EACH invoice-emb-imp OF embarque-imp NO-LOCK:
            FIND FIRST pagamento-invoice NO-LOCK
                 WHERE pagamento-invoice.embarque   = embarque-imp.embarque
                   AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice 
                   AND pagamento-invoice.parcela    = invoice-emb-imp.parcela NO-ERROR.
        
            IF AVAIL pagamento-invoice THEN DO:
                RETURN "NOK".
            END.
        END.

        /*Ponto de Embarque j† efetivado, n∆o est† mais dispon°vel*/
        IF CAN-FIND (FIRST historico-embarque 
                     WHERE historico-embarque.cod-estabel   = estabelec.cod-estabel
                       AND historico-embarque.embarque      = ordens-embarque.embarque
                       AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                       AND historico-embarque.cod-pto-contr = itinerario.pto-embarque
                       AND historico-embarque.dt-efetiva   <> ?) THEN
            RETURN "NOK".
    END.

    IF MSG0226.CodigoDespachante <> ? THEN DO:
        IF MSG0226.CodigoDespachante <> embarque-imp.cod-despachante 
        OR NOT CAN-FIND (FIRST historico-embarque 
                         WHERE historico-embarque.cod-estabel     = estabelec.cod-estabel
                           AND historico-embarque.embarque        = ordens-embarque.embarque
                           AND historico-embarque.dt-efetiva   <> ?)  THEN
            RETURN "NOK".
    END.

    IF MSG0226.NumeroEmbarque <> ? THEN DO:
        IF MSG0226.NumeroEmbarque  <> embarque-imp.embarque THEN
            RETURN "NOK".

    END.

    IF MSG0226.DISiscomex <> ? THEN DO:
        IF embarque-imp.declaracao-import <> MSG0226.DISiscomex THEN
            RETURN "NOK".
    END.

    
    IF MSG0226.MatriculaComprador <> ? THEN DO: 
        IF ordem-compra.cod-comprado <> MSG0226.MatriculaComprador THEN
            RETURN "NOK".

    END.

    IF MSG0226.NumeroPedidoCompra <> ? THEN DO: 
        IF ordem-compra.num-pedido <> MSG0226.NumeroPedidoCompra THEN
            RETURN "NOK".

    END.

    IF  MSG0226.CodigoProdutoInicial <> ? 
    AND MSG0226.CodigoProdutoFinal   <> ? THEN DO: 
        FIND FIRST b-ordem-compra NO-LOCK
             WHERE b-ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-ERROR.

        IF b-ordem-compra.it-codigo > MSG0226.CodigoProdutoFinal
        OR b-ordem-compra.it-codigo < MSG0226.CodigoProdutoInicial THEN
            RETURN "NOK".
    END.

    /*Ponto de Chegada*/ 
    IF  MSG0226.DataInicialChegada <> ? 
    AND MSG0226.DataFinalChegada   <> ? 
    AND AVAIL b2-historico-embarque THEN DO: 

         IF b2-historico-embarque.dt-efetiva <> ? THEN DO:
             IF b2-historico-embarque.dt-efetiva > MSG0226.DataFinalChegada
             OR b2-historico-embarque.dt-efetiva < MSG0226.DataInicialChegada THEN
                 RETURN "NOK".
         END.
         ELSE DO:
             IF b2-historico-embarque.dt-ult-previsao > MSG0226.DataFinalChegada
             OR b2-historico-embarque.dt-ult-previsao < MSG0226.DataInicialChegada THEN
                 RETURN "NOK".
         END.
    END.

    IF MSG0226.SituacaoEmbarque <> ? THEN DO: 
        /*Quando nao tem tt-emb a situaá∆o Ç 1*/
        IF AVAIL tt-emb THEN DO:
            IF MSG0226.SituacaoEmbarque <> tt-emb.situacao THEN
                RETURN "NOK".
        END.
        ELSE DO:
            IF MSG0226.SituacaoEmbarque <> 1 THEN
               /* NEXT. */
                RETURN "NOK".
        END.
    END.

    IF  MSG0226.StatusEmbarque <> ? 
    AND MSG0226.StatusEmbarque <> 3 THEN DO: 
        IF embarque-imp.situacao <> MSG0226.StatusEmbarque THEN
            RETURN "NOK".

    END.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

    RUN pi-busca-criticidade.

    IF MSG0226.NivelCriticidade <> ? THEN DO: 
        IF NOT AVAIL int-criticidade-item
        OR (AVAIL int-criticidade-item AND int-criticidade-item.nivel-criticidade <> MSG0226.NivelCriticidade) THEN
            RETURN "NOK".
    END.

    IF MSG0226.CodigoViaTransporte <> ? THEN DO: 
        IF MSG0226.CodigoViaTransporte <> embarque-imp.cod-via-transp THEN
            RETURN "NOK".

    END.

    IF MSG0226.CodigoIncoterm <> ? THEN DO: 
        IF SUBSTRING(cotacao-item.char-1,21,3) <> MSG0226.CodigoIncoterm THEN
            RETURN "NOK".

    END.

    IF MSG0226.CodigoItinerario <> ? THEN DO: 
        IF cotacao-item.int-1 <> MSG0226.CodigoItinerario THEN
            RETURN "NOK".

    END.

    IF MSG0226.CodigoEstabelecimento <> ? THEN DO: 
        IF embarque-imp.cod-estabel <> MSG0226.CodigoEstabelecimento THEN
            RETURN "NOK".
    END.
    
    IF MSG0226.CodigoFornecedorEMS <> ? THEN DO: 
        IF cotacao-item.cod-emitente <> MSG0226.CodigoFornecedorEMS THEN
            RETURN "NOK".

    END.


    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-situacao :

    {esp/imp/esimp000.i}
END PROCEDURE.

PROCEDURE pi-busca-criticidade:
           
    DEFINE VARIABLE i-cd-plano AS INTEGER   NO-UNDO.

    CASE ordem-compra.cod-estabel:
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

    FIND LAST int-criticidade-item NO-LOCK 
        WHERE int-criticidade-item.cod-estabel = ordem-compra.cod-estabel
          AND int-criticidade-item.cd-plano    = i-cd-plano
          AND int-criticidade-item.it-codigo   = ITEM.it-codigo NO-ERROR.
            
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

