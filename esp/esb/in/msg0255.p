CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEFINE VARIABLE de-valor-invoice     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-dat-fft            AS DATE        NO-UNDO.
DEFINE VARIABLE d-dt-prev-fecha-cam  AS DATE        NO-UNDO.
DEFINE VARIABLE l-antecipado         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE da-base              AS DATE NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='utf-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>LISTAR_FABRICANTES_ITEM</NumeroOperacao>                    */
/*     <CodigoMensagem>MSG0255</CodigoMensagem>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0255>                                                                   */
/*       <CodigoSolicitacaoInterna>42115</CodigoSolicitacaoInterna>                */
/*       <Fatura>                                                                  */
/*         <NumeroEmbarque>319456</NumeroEmbarque>                                 */
/*         <CodigoEstabelecimento>101</CodigoEstabelecimento>                      */
/*         <NumeroInvoice>384504401</NumeroInvoice>                                */
/*         <ParcelaInvoice>1</ParcelaInvoice>                                      */
/*       </Fatura>                                                                 */
/*      <Fatura>                                                                   */
/*         <NumeroEmbarque>319456</NumeroEmbarque>                                 */
/*         <CodigoEstabelecimento>101</CodigoEstabelecimento>                      */
/*         <NumeroInvoice>424364802</NumeroInvoice>                                */
/*         <ParcelaInvoice>1</ParcelaInvoice>                                      */
/*       </Fatura>                                                                 */
/*     </MSG0255>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0255.i}
{utp/ut-glob.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0255, Fatura
   DATA-RELATION FOR conteudo, msg0255 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0255, Fatura   RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0255R1, resultado
   DATA-RELATION FOR conteudor, msg0255R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0255R1, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

DEFINE BUFFER b-int-criticidade-item FOR int-criticidade-item.
DEFINE BUFFER b-historico-embarque   FOR historico-embarque.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0255R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0255 NO-ERROR.

CREATE conteudor.
CREATE msg0255R1.
CREATE resultado.

RUN pi-grava-invoice-pagamento.

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

PROCEDURE pi-grava-invoice-pagamento:

    blk_invoice_pagamento:
    DO TRANSACTION
    ON ERROR UNDO blk_invoice_pagamento, LEAVE blk_invoice_pagamento
    ON STOP  UNDO blk_invoice_pagamento, LEAVE blk_invoice_pagamento: 

        FOR EACH Fatura:
            FIND FIRST invoice-emb-imp NO-LOCK 
                 WHERE invoice-emb-imp.cod-estabel = Fatura.CodigoEstabelecimento
                   AND invoice-emb-imp.embarque    = Fatura.NumeroEmbarque
                   AND invoice-emb-imp.nr-invoice  = Fatura.NumeroInvoice
                   AND invoice-emb-imp.parcela     = Fatura.ParcelaInvoice NO-ERROR.

            IF AVAIL invoice-emb-imp THEN DO:
            
                FIND FIRST pagamento NO-LOCK
                     WHERE pagamento.nr-pagamento = msg0255.CodigoSolicitacaoInterna
                       AND pagamento.cod-estabel  = Fatura.CodigoEstabelecimento NO-ERROR.

                IF NOT AVAIL pagamento THEN DO:

                    RUN pi-erro (INPUT "N∆o encontrado SIP " + string(msg0255.CodigoSolicitacaoInterna) + " com estabelecimento " + Fatura.CodigoEstabelecimento).

                    NEXT.
                END.

                IF CAN-FIND (FIRST pagamento-invoice
                             WHERE pagamento-invoice.nr-pagamento = msg0255.CodigoSolicitacaoInterna
                               AND pagamento-invoice.embarque     = invoice-emb-imp.embarque
                               AND pagamento-invoice.nr-invoice   = invoice-emb-imp.nr-invoice
                               AND pagamento-invoice.parcela      = invoice-emb-imp.parcela) THEN DO:

                    RUN pi-erro (INPUT "SIP ja cadastrada com estabelecimento  " + string(Fatura.CodigoEstabelecimento) + " embarque " + STRING(Fatura.NumeroEmbarque) + " parcela " + STRING(Fatura.ParcelaInvoice)).

                    NEXT.   
                END.

                /*Se j† tem invoice vinculada, valida a moeda*/
                IF CAN-FIND (FIRST pagamento-invoice
                             WHERE pagamento-invoice.nr-pagamento = msg0255.CodigoSolicitacaoInterna) THEN DO:
                
                    IF pagamento.cod-moeda <> invoice-emb-imp.mo-codigo THEN DO:
                        RUN pi-erro (INPUT "Moeda da invoice n∆o pode ser diferente da moeda da SIP").
                        NEXT.   
                    END.
                END.
                /*Se Ç a primeira fatura vinculada preenche a moeda*/
                ELSE DO:
                    FIND CURRENT pagamento EXCLUSIVE-LOCK.
                    ASSIGN pagamento.cod-moeda = invoice-emb-imp.mo-codigo.
                    FIND CURRENT pagamento NO-LOCK.
                END.
                
                CREATE pagamento-invoice.
                ASSIGN pagamento-invoice.nr-pagamento = msg0255.CodigoSolicitacaoInterna
                       pagamento-invoice.embarque     = invoice-emb-imp.embarque
                       pagamento-invoice.nr-invoice   = invoice-emb-imp.nr-invoice
                       pagamento-invoice.parcela      = invoice-emb-imp.parcela
                       pagamento-invoice.valor        = invoice-emb-imp.vl-invoice.
            END.
            ELSE 
                RUN pi-erro (INPUT "N∆o encontrada invoice com estabelecimento " + string(Fatura.CodigoEstabelecimento) + " embarque " + STRING(Fatura.NumeroEmbarque) + " parcela " + STRING(Fatura.ParcelaInvoice)).
        END.

        FIND FIRST pagamento NO-LOCK
             WHERE pagamento.nr-pagamento = msg0255.CodigoSolicitacaoInterna NO-ERROR.

        FOR EACH pagamento-invoice NO-LOCK
           WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pagamento:

            ASSIGN de-valor-invoice = de-valor-invoice + pagamento-invoice.valor.
        END.

        FIND FIRST int-cond-pagto NO-LOCK
             WHERE int-cond-pagto.cod-cond-pag = pagamento.cod-cond-pag NO-ERROR.
        
        RUN pi-calcula-campos (INPUT  pagamento.nr-pagamento,
                               OUTPUT d-dt-prev-fecha-cam,
                               OUTPUT d-dat-fft,
                               OUTPUT l-antecipado).

        IF CAN-FIND (tt-erro) THEN
            UNDO blk_invoice_pagamento, LEAVE blk_invoice_pagamento.

        FIND CURRENT pagamento EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL pagamento THEN DO:
            ASSIGN pagamento.valor-pag          = de-valor-invoice
                   pagamento.dt-prev-fecha-cam  = d-dt-prev-fecha-cam
                   pagamento.dat-fft            = d-dat-fft
                   pagamento.log-pag-antecipado = l-antecipado.

            RELEASE pagamento.
        END.

        IF CAN-FIND (tt-erro) THEN
            UNDO blk_invoice_pagamento, LEAVE blk_invoice_pagamento.
    END.

    IF CAN-FIND (tt-erro) THEN
        RETURN "NOK".

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-calcula-campos:
    DEFINE INPUT  PARAM p-nr-pagamento      LIKE pagamento.nr-pagamento.
    DEFINE OUTPUT PARAM p-dat-prev-fech-cam LIKE pagamento.dt-prev-fecha-cam INITIAL ?.
    DEFINE OUTPUT PARAM p-dat-fft           LIKE pagamento.dat-fft           INITIAL ?.
    DEFINE OUTPUT PARAM p-antecipado        AS LOGICAL                       INITIAL NO.

    DEF VAR i-dias AS INT NO-UNDO.
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


        FIND FIRST int-cond-pagto NO-LOCK
             WHERE int-cond-pagto.cod-cond-pag = pagamento.cod-cond-pag NO-ERROR.

        IF AVAIL invoice-emb-imp THEN DO:
            ASSIGN p-dat-prev-fech-cam = invoice-emb-imp.dt-vencim.

            /*Desconta 2 dias £teis*/
            IF  AVAIL int-cond-pagto AND int-cond-pagto.log-controla-fft THEN DO:
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
    
                    IF (AVAIL calen-coml AND calen-coml.tipo-dia = 1) THEN DO:
                        LEAVE.
                    END.
                    ELSE
                        IF  NOT AVAIL calen-coml AND (WEEKDAY(p-dat-prev-fech-cam) <> 7 AND WEEKDAY(p-dat-prev-fech-cam) <> 1) THEN
                            LEAVE.
                    ASSIGN p-dat-prev-fech-cam = p-dat-prev-fech-cam + 1.
                END.

            END.
        END.

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
        
                    FIND FIRST tb-pr-cc NO-LOCK 
                         WHERE /*tb-pr-cc.cod-estabel  = pedido-compr.cod-estabel
                           AND*/ tb-pr-cc.cod-emitente = pedido-compr.cod-emitente 
                           AND tb-pr-cc.cod-cond-pag = pagamento.cod-cond-pag
                           AND tb-pr-cc.mo-codigo    = cotacao-item.mo-codigo    
                           /*AND tb-pr-cc.dt-inicio   <= TODAY
                           AND tb-pr-cc.situacao     = 1*/ NO-ERROR.
        
                    IF NOT AVAIL tb-pr-cc THEN
                        FIND FIRST tb-pr-cc NO-LOCK 
                             WHERE tb-pr-cc.cod-emitente = pedido-compr.cod-emitente 
                               AND tb-pr-cc.cod-cond-pag = ordem-compra.cod-cond-pag
                               AND tb-pr-cc.mo-codigo    = cotacao-item.mo-codigo    
                               /*AND tb-pr-cc.dt-inicio   <= TODAY 
                               AND tb-pr-cc.situacao     = 1*/ NO-ERROR.
                    
                    IF AVAIL tb-pr-cc THEN DO:
                        FIND FIRST int-tb-pr-cc OF tb-pr-cc NO-LOCK NO-ERROR.

                        ASSIGN p-dat-fft = (historico-embarque.dt-efetiva +  int-tb-pr-cc.num-dias-libera-fft). /*- 2*/
        
                        FOR FIRST cond-pagto NO-LOCK
                            WHERE cond-pagto.cod-cond-pag = int-cond-pagto.cod-cond-pag
                               AND cond-pagto.cod-vencto = 6 /*Fora Quinzena*/:
                                
                              IF  int-cond-pagto.log-controla-fft THEN DO:
                                  ASSIGN da-base = p-dat-fft 
                                         da-base = DATE(MONTH(da-base), 28, YEAR(da-base)) + 5
                                         da-base = DATE(MONTH(da-base), cond-pagto.dia-mes-venc, YEAR(da-base)).
                                  
                              END.
                              ELSE
                                  ASSIGN da-base = p-dat-fft.
                               
                        END.
                        IF  NOT AVAIL cond-pagto THEN
                            ASSIGN da-base = p-dat-fft.

                        /*Desconta 2 dias £teis*/
                        ASSIGN i-dias = 0.
                        REPEAT:
                            IF  i-dias = 2 THEN
                                LEAVE.

                            FIND FIRST calen-coml
                                 WHERE calen-coml.cod-estabel = pedido-compr.cod-estabel
                                   AND calen-coml.ep-codigo   = v_cdn_empres_usuar
                                   AND calen-coml.data        = da-base NO-LOCK NO-ERROR.

                            ASSIGN da-base = da-base - 1.

                            IF  (AVAIL calen-coml AND calen-coml.tipo-dia <> 1)
                            OR  (WEEKDAY(da-base) = 7 OR WEEKDAY(da-base) = 1) THEN
                                NEXT.
                            ASSIGN i-dias = i-dias + 1.

                        END.
                        
                        ASSIGN p-dat-fft = da-base.

                    END.
                    ELSE DO:
                        RUN pi-erro ("N∆o encontrado tabela de preáos para o c†lculo da data FFT").
                    END.
                END. /*historico-embarque.dt-efetiva <> ?*/
            END. /*AVAIL historico-embarque*/
        END.
    END.

    /*Pagamento antecipado*/
    ASSIGN p-antecipado = NO.
    
    blk_antecipado:
    FOR EACH pagamento-invoice NO-LOCK 
       WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pagamento:

        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel = pagamento.cod-estabel
               AND historico-embarque.embarque    = pagamento-invoice.embarque NO-ERROR.
    
        FIND FIRST itinerario NO-LOCK
             WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.
    
        /*Verifica se o ponto de embarque est† efetivado*/
        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel   = pagamento.cod-estabel
               AND historico-embarque.embarque      = pagamento-invoice.embarque
               AND historico-embarque.cod-pto-contr = itinerario.pto-embarque 
               AND historico-embarque.dt-efetiva    <> ? NO-ERROR.
    
        IF AVAIL historico-embarque THEN DO:
            FIND FIRST invoice-emb-imp NO-LOCK
                 WHERE invoice-emb-imp.cod-estabel = pagamento.cod-estabel
                   AND invoice-emb-imp.embarque    = pagamento-invoice.embarque       
                   AND invoice-emb-imp.nr-invoice  = pagamento-invoice.nr-invoice
                   AND invoice-emb-imp.parcela     = pagamento-invoice.parcela    NO-ERROR.
    
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
