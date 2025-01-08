CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.
DEFINE VARIABLE de-valor-invoice     AS DECIMAL     NO-UNDO.                        
DEFINE VARIABLE d-dat-fft            AS DATE        NO-UNDO.
DEFINE VARIABLE d-dt-prev-fecha-cam  AS DATE        NO-UNDO.
DEFINE VARIABLE l-antecipado         AS LOGICAL     NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                            */


/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='utf-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>REMOVER_SIP_DE_FATURAS</NumeroOperacao>                     */
/*     <CodigoMensagem>MSG0260</CodigoMensagem>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0260>                                                                   */
/*       <CodigoSolicitacaoInterna>42113</CodigoSolicitacaoInterna>                */
/*       <Fatura>                                                                  */
/*         <NumeroEmbarque>305696</NumeroEmbarque>                                 */
/*         <CodigoEstabelecimento>101</CodigoEstabelecimento>                      */
/*         <NumeroInvoice>1063802</NumeroInvoice>                                  */
/*         <ParcelaInvoice>1</ParcelaInvoice>                                      */
/*       </Fatura>                                                                 */
/*     </MSG0260>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0260.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0260, Fatura
   DATA-RELATION FOR conteudo, msg0260 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0260, Fatura   RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0260R1, resultado
   DATA-RELATION FOR conteudor, msg0260R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0260R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0260R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0260 NO-ERROR.

CREATE conteudor.
CREATE msg0260R1.
CREATE resultado.

RUN pi-elimina-invoice-despesa.

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

PROCEDURE pi-elimina-invoice-despesa:

    blk_pagamento:
    DO TRANSACTION
    ON ERROR UNDO blk_pagamento, LEAVE blk_pagamento
    ON STOP  UNDO blk_pagamento, LEAVE blk_pagamento: 

        FIND FIRST pagamento NO-LOCK
             WHERE pagamento.nr-pagamento = msg0260.CodigoSolicitacaoInterna NO-ERROR.

        IF NOT AVAIL pagamento THEN DO:
            RUN pi-erro (INPUT "NÆo encontrada SIP: " + STRING(msg0260.CodigoSolicitacaoInterna)).
            RETURN "NOK".
        END.

        IF pagamento.recebido-ap THEN DO:
            RUN pi-erro (INPUT "SIP: " + STRING(msg0260.CodigoSolicitacaoInterna) + " SIP j  foi recebida no Financeiro. D£vidas entrar em contato com o setor financeiro.").
            RETURN "NOK".
        END.

        FOR EACH Fatura:

            FIND FIRST pagamento-invoice EXCLUSIVE-LOCK
                 WHERE pagamento-invoice.embarque   = Fatura.NumeroEmbarque
                   AND pagamento-invoice.nr-invoice = Fatura.NumeroInvoice
                   AND pagamento-invoice.parcela    = Fatura.ParcelaInvoice NO-ERROR.

            IF AVAIL pagamento-invoice THEN DO:
                DELETE pagamento-invoice.
            END.
            ELSE DO:
                RUN pi-erro (INPUT "NÆo encontrado fatura informada.").
            END.

            /*Se desvinculou a £ltima invoice, "zera" moeda*/
            IF NOT CAN-FIND (FIRST pagamento-invoice
                             WHERE pagamento-invoice.nr-pagamento = msg0260.CodigoSolicitacaoInterna) THEN DO:
                FIND CURRENT pagamento EXCLUSIVE-LOCK.
                ASSIGN pagamento.cod-moeda = 0.
                FIND CURRENT pagamento NO-LOCK.
            END.
        END.

        ASSIGN de-valor-invoice = 0.

        
        RUN pi-calcula-campos (INPUT  pagamento.nr-pagamento,
                               OUTPUT d-dt-prev-fecha-cam,
                               OUTPUT d-dat-fft,
                               OUTPUT l-antecipado).
        
        IF CAN-FIND (tt-erro) THEN
            UNDO blk_pagamento, LEAVE blk_pagamento.

        FOR EACH pagamento-invoice NO-LOCK
           WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pagamento:

            ASSIGN de-valor-invoice = de-valor-invoice + pagamento-invoice.valor.
        END.

        FIND CURRENT pagamento EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL pagamento THEN DO:
            ASSIGN pagamento.valor-pag          = de-valor-invoice
                   pagamento.dt-prev-fecha-cam  = d-dt-prev-fecha-cam
                   pagamento.dat-fft            = d-dat-fft
                   pagamento.log-pag-antecipado = l-antecipado.
         
            RELEASE pagamento.
        END.
    END.
    
    IF NOT CAN-FIND (FIRST tt-erro) THEN
        RETURN "OK".
    ELSE 
        RETURN "NOK".
END PROCEDURE.

PROCEDURE pi-calcula-campos:
    DEFINE INPUT  PARAM p-nr-pagamento      LIKE pagamento.nr-pagamento.
    DEFINE OUTPUT PARAM p-dat-prev-fech-cam LIKE pagamento.dt-prev-fecha-cam INITIAL ?.
    DEFINE OUTPUT PARAM p-dat-fft           LIKE pagamento.dat-fft           INITIAL ?.
    DEFINE OUTPUT PARAM p-antecipado        AS LOGICAL                       INITIAL NO.

    DEF VAR i-dias AS INTEGER NO-UNDO.

    FIND FIRST pagamento NO-LOCK 
         WHERE pagamento.nr-pagamento = p-nr-pagamento NO-ERROR.

    FIND FIRST pagamento-invoice NO-LOCK 
         WHERE pagamento-invoice.nr-pagamento = p-nr-pagamento NO-ERROR.

    IF AVAIL pagamento-invoice THEN DO:
        /*Busca dat-prev-fech-cam*/
        FIND FIRST invoice-emb-imp NO-LOCK 
             WHERE invoice-emb-imp.cod-estabel = pagamento.cod-estabel
               AND invoice-emb-imp.embarque    = pagamento-invoice.embarque
               AND invoice-emb-imp.nr-invoice  = pagamento-invoice.nr-invoice
               AND invoice-emb-imp.parcela     = pagamento-invoice.parcela NO-ERROR.

        IF AVAIL invoice-emb-imp THEN DO:
            ASSIGN p-dat-prev-fech-cam = invoice-emb-imp.dt-vencim.

            /*Desconta 2 dias £teis*/
            IF  p-dat-fft <> ? THEN DO:
                ASSIGN i-dias = 0.
                REPEAT:
                    IF  i-dias = 2 THEN
                        LEAVE.
    
                    FIND FIRST calen-coml
                         WHERE calen-coml.cod-estabel = pagamento.cod-estabel
                           AND calen-coml.ep-codigo   = v_cdn_empres_usuar
                           AND calen-coml.data        = p-dat-prev-fech-cam NO-LOCK NO-ERROR.
    
                    ASSIGN p-dat-prev-fech-cam = p-dat-prev-fech-cam - 1.
                
                    IF  (AVAIL calen-coml AND calen-coml.tipo-dia <> 1)
                    OR  (WEEKDAY(p-dat-prev-fech-cam) = 7 OR WEEKDAY(p-dat-prev-fech-cam) = 1) THEN
                        NEXT.
                    ASSIGN i-dias = i-dias + 1 .
                END.
            END.
            ELSE DO:
               REPEAT:
                    FIND FIRST calen-coml
                         WHERE calen-coml.cod-estabel = pagamento.cod-estabel
                           AND calen-coml.ep-codigo   = v_cdn_empres_usuar
                           AND calen-coml.data        = p-dat-prev-fech-cam NO-LOCK NO-ERROR.
    
                    IF  (AVAIL calen-coml AND calen-coml.tipo-dia = 1) THEN DO:
                         LEAVE.
                    END.
                    ELSE
                        IF  NOT AVAIL calen-coml AND (WEEKDAY(p-dat-prev-fech-cam) <> 7 AND WEEKDAY(p-dat-prev-fech-cam) <> 1) THEN
                            LEAVE.
                    ASSIGN p-dat-prev-fech-cam = p-dat-prev-fech-cam + 1.
                END.

            END.
        END.

        FIND FIRST int-cond-pagto NO-LOCK
             WHERE int-cond-pagto.cod-cond-pag = pagamento.cod-cond-pag NO-ERROR.

        IF  AVAIL int-cond-pagto
        AND int-cond-pagto.log-controla-fft THEN DO:
            /*Busca dat-fft*/
            FIND FIRST ordens-embarque NO-LOCK
                 WHERE ordens-embarque.cod-estabel = pagamento.cod-estabel
                   AND ordens-embarque.embarque    = invoice-emb-imp.embarque NO-ERROR.
    
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-ERROR.
    
            FIND FIRST pedido-compr NO-LOCK
                 WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.
    
            FIND FIRST cotacao-item NO-LOCK
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                   AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
                   AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.
    
            FIND FIRST historico-embarque NO-LOCK
                 WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel
                   AND historico-embarque.embarque    = ordens-embarque.embarque NO-ERROR.
    
            /*Ponto base da ordem*/
            FIND FIRST historico-embarque NO-LOCK
                 WHERE historico-embarque.cod-estabel   = ordens-embarque.cod-estabel
                   AND historico-embarque.embarque      = ordens-embarque.embarque
                   AND historico-embarque.cod-itiner    = historico-embarque.cod-itiner
                   AND historico-embarque.cod-pto-contr = int(SUBSTRING(cotacao-item.char-1,41,5)) NO-ERROR.
    
            IF  AVAIL historico-embarque THEN DO:
            
                IF historico-embarque.dt-efetiva <> ? THEN DO:
        
                    FIND FIRST int-tb-pr-cc NO-LOCK 
                         WHERE int-tb-pr-cc.cod-estabel  = pedido-compr.cod-estabel
                           AND int-tb-pr-cc.cod-emitente = pedido-compr.cod-emitente 
                           AND int-tb-pr-cc.cod-cond-pag = pagamento.cod-cond-pag
                           AND int-tb-pr-cc.mo-codigo    = cotacao-item.mo-codigo    
                           /*AND int-tb-pr-cc.dt-inicio   <= TODAY*/ NO-ERROR.
        
                    IF NOT AVAIL int-tb-pr-cc THEN
                        FIND FIRST int-tb-pr-cc NO-LOCK 
                             WHERE int-tb-pr-cc.cod-emitente = pedido-compr.cod-emitente 
                               AND int-tb-pr-cc.cod-cond-pag = ordem-compra.cod-cond-pag
                               AND int-tb-pr-cc.mo-codigo    = cotacao-item.mo-codigo    
                               /*AND int-tb-pr-cc.dt-inicio   <= TODAY*/ NO-ERROR.
                    
                    IF AVAIL int-tb-pr-cc THEN DO:
                        ASSIGN p-dat-fft = (historico-embarque.dt-efetiva +  int-tb-pr-cc.num-dias-libera-fft) - 2.
        
                        /*Desconta 2 dias £teis*/
                        ASSIGN i-dias = 0.
                        REPEAT:
                            IF  i-dias = 2 THEN
                                LEAVE.
                            FIND FIRST calen-coml
                                 WHERE calen-coml.cod-estabel = pedido-compr.cod-estabel
                                   AND calen-coml.ep-codigo   = v_cdn_empres_usuar
                                   AND calen-coml.data        = p-dat-fft NO-LOCK NO-ERROR.
        
                            ASSIGN p-dat-fft = p-dat-fft - 1.
                        
                            IF  (AVAIL calen-coml AND calen-coml.tipo-dia <> 1)
                            OR  (WEEKDAY(p-dat-fft) = 7 OR WEEKDAY(p-dat-fft) = 1) THEN
                                NEXT.

                            ASSIGN i-dias = i-dias + 1 .
                        END.
                    END.
                    ELSE DO:
                        RUN pi-erro ("NÆo encontrado tabela de pre‡os para o c lculo da data FFT").
                    END.
                END. /*historico-embarque.dt-efetiva <> ?*/
            END. /*AVAIL historico-embarque*/
        END.
    END.

    /*Pagamento antecipado*/
    ASSIGN p-antecipado = NO.
    
    blk_antecipado:
    FOR EACH invoice-emb-imp NO-LOCK 
       WHERE invoice-emb-imp.cod-estabel = pagamento.cod-estabel
         AND invoice-emb-imp.embarque    = pagamento-invoice.embarque:

        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel = pagamento.cod-estabel
               AND historico-embarque.embarque    = pagamento-invoice.embarque NO-ERROR.

        FIND FIRST itinerario NO-LOCK
             WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.
    
        /*Verifica se o ponto de embarque est  efetivado*/
        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel   = invoice-emb-imp.cod-estabel
               AND historico-embarque.embarque      = invoice-emb-imp.embarque
               AND historico-embarque.cod-pto-contr = itinerario.pto-embarque 
               AND historico-embarque.dt-efetiva    <> ? NO-ERROR.
    
        IF AVAIL historico-embarque THEN DO:
            IF historico-embarque.dt-efetiva > invoice-emb-imp.dt-vencim THEN DO:
                ASSIGN p-antecipado = YES.
                LEAVE blk_antecipado.
            END.
        END.
        ELSE DO:
            ASSIGN p-antecipado = YES.
            LEAVE blk_antecipado.
        END.
    END.

    IF CAN-FIND (tt-erro) THEN
        RETURN "NOK".

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
