/*****************************************************************************
*****************************************************************************/
{include/i-prgvrs.i UPC-RE1005B6 2.00.00.001 } /*** 010001 ***/

{include/i-epc200.i }
{METHOD/dbotterr.i}

DEF INPUT        PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEF VAR h-tt-ficha      AS HANDLE NO-UNDO.
DEF VAR h-bf-ficha      AS HANDLE NO-UNDO.
DEF VAR h-qr-ficha      AS HANDLE NO-UNDO.
DEF VAR c-serie-docto   AS CHAR   NO-UNDO.
DEF VAR c-nro-docto     AS CHAR   NO-UNDO.
DEF VAR c-nat-operacao  AS CHAR   NO-UNDO.
DEF VAR c-cod-estabel   AS CHAR   NO-UNDO.
DEF VAR c-it-codigo     AS CHAR   NO-UNDO.
DEF VAR c-cod-depos     AS CHAR   NO-UNDO.
DEF VAR c-cod-localiz   AS CHAR   NO-UNDO.
DEF VAR c-lote          AS CHAR   NO-UNDO.
DEF VAR i-cod-emitente  AS INT    NO-UNDO.
DEF VAR i-nr-ficha-cq   AS INT    NO-UNDO.
DEF VAR i-sequen-nf     AS INT    NO-UNDO.
DEF VAR l-faz-cq        AS LOG    NO-UNDO.
DEF VAR l-item-doc      AS LOG    NO-UNDO.
DEF VAR l-controle-lote AS LOG    NO-UNDO.
DEF VAR de-qtd-total    AS DEC    NO-UNDO.
DEF VAR l-agrupa-cq     AS LOG    NO-UNDO.
DEF VAR hBOSC039        AS HANDLE NO-UNDO.

DEF BUFFER bf-item-doc-est FOR item-doc-est.
DEF BUFFER bf-tt-epc       FOR tt-epc.
DEF BUFFER bf2-tt-epc      FOR tt-epc.
    
/* Valida se j  foi gerada uma ficha de CQ para o mesmo item, dep¢sito, localiza‡Æo e lote. */
IF p-ind-event = "before-create-ficha-cq" THEN DO:

    FOR FIRST tt-epc 
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "handle-tt-ficha":

        FOR FIRST bf2-tt-epc
            WHERE bf2-tt-epc.cod-event     = p-ind-event
              AND bf2-tt-epc.cod-parameter = "rowid-item-doc-est":

            IF bf2-tt-epc.val-parameter <> ? THEN DO:

                FIND FIRST item-doc-est NO-LOCK
                     WHERE ROWID(item-doc-est) = TO-ROWID(bf2-tt-epc.val-parameter) NO-ERROR.
            END.
        END.

        IF NOT AVAIL item-doc-est THEN
            RETURN "OK":U.

        ASSIGN h-tt-ficha = WIDGET-HANDLE(tt-epc.val-parameter) NO-ERROR.
    
        CREATE BUFFER h-bf-ficha FOR TABLE h-tt-ficha.
        CREATE QUERY h-qr-ficha.
        h-qr-ficha:SET-BUFFERS(h-bf-ficha).
        h-qr-ficha:QUERY-PREPARE("for each " + h-tt-ficha:NAME).
        h-qr-ficha:QUERY-OPEN().
        h-qr-ficha:GET-FIRST.
    
        IF NOT h-qr-ficha:QUERY-OFF-END THEN DO:

            ASSIGN i-cod-emitente = h-bf-ficha:BUFFER-FIELD("cod-emitente"):BUFFER-VALUE()
                   c-serie-docto  = h-bf-ficha:BUFFER-FIELD("serie-docto"):BUFFER-VALUE()
                   c-nro-docto    = h-bf-ficha:BUFFER-FIELD("nro-docto"):BUFFER-VALUE()
                   c-nat-operacao = h-bf-ficha:BUFFER-FIELD("nat-operacao"):BUFFER-VALUE()
                   c-cod-estabel  = h-bf-ficha:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE()
                   c-it-codigo    = h-bf-ficha:BUFFER-FIELD("it-codigo"):BUFFER-VALUE()
                   c-cod-depos    = h-bf-ficha:BUFFER-FIELD("cod-depos"):BUFFER-VALUE()
                   c-cod-localiz  = h-bf-ficha:BUFFER-FIELD("cod-localiz"):BUFFER-VALUE()
                   c-lote         = h-bf-ficha:BUFFER-FIELD("lote"):BUFFER-VALUE().

            ASSIGN l-agrupa-cq = NO.

            IF item-doc-est.numero-ordem <> 0
            OR CAN-FIND(FIRST rat-ordem NO-LOCK
                        WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                          AND rat-ordem.nat-operacao = item-doc-est.nat-operacao
                          AND rat-ordem.serie-docto  = item-doc-est.serie-docto
                          AND rat-ordem.nro-docto    = item-doc-est.nro-docto
                          AND rat-ordem.sequencia    = item-doc-est.sequencia) THEN DO:
                
                ASSIGN l-agrupa-cq = YES.
            END.

            IF NOT l-agrupa-cq THEN
                RETURN "OK":U.

            /* Se encontrar uma ficha de CQ cadastrada, retorna a numera‡Æo **
            ** para que o RE1005B6 possa devolver para o programa chamador. */
            FIND FIRST ficha-cq NO-LOCK
                 WHERE ficha-cq.serie-docto  = c-serie-docto
                   AND ficha-cq.nro-docto    = c-nro-docto
                   AND ficha-cq.cod-emitente = i-cod-emitente
                   AND ficha-cq.nat-operacao = c-nat-operacao
                   AND ficha-cq.cod-estabel  = c-cod-estabel
                   AND ficha-cq.cod-depos    = c-cod-depos
                   AND ficha-cq.it-codigo    = c-it-codigo
                   AND ficha-cq.cod-localiz  = c-cod-localiz
                   AND ficha-cq.lote         = c-lote NO-ERROR.

            IF AVAIL ficha-cq THEN DO:

                CREATE bf-tt-epc.
                ASSIGN bf-tt-epc.cod-event     = "before-create-ficha-cq"
                       bf-tt-epc.cod-parameter = "i-nr-ficha"
                       bf-tt-epc.val-parameter = STRING(ficha-cq.nr-ficha).
            END.
        END.
    END.
END.

/* Agrupa as quantidades dos itens do mesmo dep¢sito, localiza‡Æo e lote ap¢s gerar a ficha de CQ. */
IF p-ind-event = "Validate-ficha-cq" THEN DO:

    FOR FIRST tt-epc 
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "nr-ficha-cq":

        ASSIGN i-nr-ficha-cq = INT(tt-epc.val-parameter).
    END.
    
    FOR FIRST tt-epc 
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "i-sequen-nf":

        ASSIGN i-sequen-nf = INT(tt-epc.val-parameter).
    END.
    
    FOR FIRST tt-epc 
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "l-item-doc":

        ASSIGN l-item-doc = LOGICAL(tt-epc.val-parameter).
    END.
    
    FOR FIRST tt-epc 
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "l-faz-cq":

        ASSIGN l-faz-cq = LOGICAL(tt-epc.val-parameter).
    END.
    
    FOR FIRST ficha-cq EXCLUSIVE-LOCK
        WHERE ficha-cq.nr-ficha = i-nr-ficha-cq:

        ASSIGN de-qtd-total   = 0
               c-serie-docto  = ficha-cq.serie-docto
               c-nro-docto    = ficha-cq.nro-docto
               i-cod-emitente = ficha-cq.cod-emitente
               c-nat-operacao = ficha-cq.nat-operacao
               c-cod-estabel  = ficha-cq.cod-estabel
               c-cod-depos    = ficha-cq.cod-depos
               c-it-codigo    = ficha-cq.it-codigo
               c-cod-localiz  = ficha-cq.cod-localiz
               c-lote         = ficha-cq.lote.
    
        FOR FIRST docum-est NO-LOCK
            WHERE docum-est.serie-docto  = c-serie-docto
              AND docum-est.nro-docto    = c-nro-docto
              AND docum-est.cod-emitente = i-cod-emitente
              AND docum-est.nat-operacao = c-nat-operacao:

            FOR FIRST item-doc-est NO-LOCK
                WHERE item-doc-est.serie-docto  = docum-est.serie-docto
                  AND item-doc-est.nro-docto    = docum-est.nro-docto
                  AND item-doc-est.cod-emitente = docum-est.cod-emitente
                  AND item-doc-est.nat-operacao = docum-est.nat-operacao
                  AND item-doc-est.sequencia    = i-sequen-nf:

                ASSIGN l-agrupa-cq = NO.

                IF item-doc-est.numero-ordem <> 0
                OR CAN-FIND(FIRST rat-ordem NO-LOCK
                            WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                              AND rat-ordem.nat-operacao = item-doc-est.nat-operacao
                              AND rat-ordem.serie-docto  = item-doc-est.serie-docto
                              AND rat-ordem.nro-docto    = item-doc-est.nro-docto
                              AND rat-ordem.sequencia    = item-doc-est.sequencia) THEN DO:
                    
                    ASSIGN l-agrupa-cq = YES.
                END.

                IF NOT l-agrupa-cq THEN
                    RETURN "OK":U.

                FIND FIRST item NO-LOCK
                     WHERE item.it-codigo = item-doc-est.it-codigo NO-ERROR.

                IF AVAIL item AND item.tipo-con-est = 3 THEN /* Lote*/
                    ASSIGN l-controle-lote = YES.
    
                FOR EACH rat-lote NO-LOCK
                   WHERE rat-lote.serie        = item-doc-est.serie-docto  
                     AND rat-lote.nro-docto    = item-doc-est.nro-docto  
                     AND rat-lote.cod-emitente = item-doc-est.cod-emitente
                     AND rat-lote.nat-operacao = item-doc-est.nat-operacao  
                     AND rat-lote.it-codigo    = item-doc-est.it-codigo   
                     AND rat-lote.sequencia    = item-doc-est.sequencia
                     AND rat-lote.cod-depos    = c-cod-depos
                     AND rat-lote.cod-localiz  = c-cod-localiz:
    
                    IF l-controle-lote AND rat-lote.lote <> c-lote THEN
                        NEXT.
                        
                    ASSIGN de-qtd-total = de-qtd-total + rat-lote.quantidade.
                END.
    
                FOR EACH bf-item-doc-est NO-LOCK
                   WHERE bf-item-doc-est.serie-docto   = item-doc-est.serie-docto
                     AND bf-item-doc-est.nro-docto     = item-doc-est.nro-docto
                     AND bf-item-doc-est.cod-emitente  = item-doc-est.cod-emitente
                     AND bf-item-doc-est.nat-operacao  = item-doc-est.nat-operacao
                     AND bf-item-doc-est.it-codigo     = item-doc-est.it-codigo
                     AND bf-item-doc-est.sequencia    <> item-doc-est.sequencia:
                    
                    FOR EACH rat-lote NO-LOCK
                       WHERE rat-lote.serie        = bf-item-doc-est.serie-docto  
                         AND rat-lote.nro-docto    = bf-item-doc-est.nro-docto  
                         AND rat-lote.cod-emitente = bf-item-doc-est.cod-emitente
                         AND rat-lote.nat-operacao = bf-item-doc-est.nat-operacao  
                         AND rat-lote.it-codigo    = bf-item-doc-est.it-codigo   
                         AND rat-lote.sequencia    = bf-item-doc-est.sequencia
                         AND rat-lote.cod-depos    = c-cod-depos
                         AND rat-lote.cod-localiz  = c-cod-localiz:
                        
                        IF  l-controle-lote AND rat-lote.lote <> c-lote THEN
                            NEXT.

                        ASSIGN de-qtd-total = de-qtd-total + rat-lote.quantidade.
                    END.
                END.

                ASSIGN ficha-cq.qt-original = IF l-item-doc   THEN 0            ELSE de-qtd-total
                       ficha-cq.qt-aprovada = IF NOT l-faz-cq THEN de-qtd-total ELSE 0.

                /* Ajustando WMS */
                FIND FIRST wm-roteiro-docto-itens WHERE
                    wm-roteiro-docto-itens.nr-ficha = ficha-cq.nr-ficha NO-LOCK NO-ERROR.

                IF AVAIL wm-roteiro-docto-itens THEN DO:
                    FIND FIRST wm-docto-itens OF wm-roteiro-docto-itens NO-LOCK NO-ERROR.
                    IF AVAIL wm-docto-itens AND
                       wm-docto-itens.qtd-item <> de-qtd-total THEN DO:
                        FOR EACH wm-box-movto OF wm-docto-itens WHERE 
                            wm-box-movto.ind-tipo-movto = 1 NO-LOCK:
                            RUN wmp\wm9032.p (INPUT  ROWID(wm-box-movto),
                                              OUTPUT TABLE RowErrors).
                        END.

                        FIND FIRST RowErrors NO-ERROR.
                        FOR EACH RowErrors:
                            END.

                        FIND CURRENT wm-docto-itens EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL wm-docto-itens THEN DO:
                            ASSIGN wm-docto-itens.qtd-item = de-qtd-total.
                        END.
    
                        FIND FIRST wm-local WHERE
                            wm-local.cod-estabel = wm-docto-itens.cod-estabel AND
                            wm-local.cod-local   = wm-docto-itens.cod-local   NO-LOCK NO-ERROR.
                        IF AVAIL wm-local AND wm-local.log-2 = NO THEN DO:
                            IF NOT VALID-HANDLE(hBOSC039) THEN
                                RUN scbo/bosc039.p PERSISTENT SET hBOSC039.
                            RUN sugestaoAlocacaoItem IN hBOSC039 (INPUT wm-docto-itens.cod-estabel,
                                                                  INPUT wm-docto-itens.cod-local,
                                                                  INPUT wm-docto-itens.id-docto,
                                                                  INPUT wm-docto-itens.num-seq-item).
                            IF VALID-HANDLE(hBOSC039) THEN
                                DELETE OBJECT hBOSC039.
                        END.
                    END.
                END.

            END.
        END.
    END.
END.

//RETURN "OK":U.
