/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
*******************************************************************************/

/* Programa EPC para boin367 */

{include/i-epc200.i1}

def input param  p-ind-event as char no-undo.
def input-output param table for tt-epc.

DEFINE VARIABLE h_boin367 AS WIDGET-HANDLE NO-UNDO. 
DEFINE VARIABLE c-depos AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-numero-ordem AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-lote AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-data AS DATE        NO-UNDO.
DEFINE VARIABLE l-atualiza AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-sugeriu-lote AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-transf-estabs AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-retorno AS LOGICAL     NO-UNDO.
DEF BUFFER b-docum-est FOR docum-est.
DEF BUFFER b-rat-lote FOR rat-lote.    

{include/boerrtab.i}
/* {inbo/boin367.i tt-rat-lote} */
{esp/es0018.i}

DEFINE TEMP-TABLE tt-rat-lote NO-UNDO LIKE rat-lote
FIELD r-rowid AS ROWID.
FIND FIRST tt-epc. 

CASE p-ind-event:
    WHEN "afterValidateItem" THEN DO:
        ASSIGN l-sugeriu-lote = NO. 
        for first tt-epc where tt-epc.cod-event = p-ind-event:
            if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:    
                ASSIGN h_boin367 =  WIDGET-HANDLE(tt-epc.val-parameter).
                
                RUN getCharField IN h_boin367 (INPUT "cod-depos", OUTPUT c-depos).    
                RUN getCharField IN h_boin367 (INPUT "it-codigo", OUTPUT c-item).
                
                /*IF  c-depos = "REC" OR c-depos = "CST" THEN*/
                RUN getrecord IN h_boin367 (OUTPUT TABLE tt-rat-lote).
                            
                FIND FIRST tt-rat-lote NO-ERROR.
                IF AVAIL tt-rat-lote THEN DO:
                    ASSIGN l-sugeriu-lote = NO.
                    FIND FIRST b-docum-est OF tt-rat-lote NO-LOCK NO-ERROR.
                    IF AVAIL b-docum-est THEN DO:
                        FIND FIRST ITEM NO-LOCK
                             WHERE ITEM.it-codigo = c-item NO-ERROR.
                        IF AVAIL ITEM THEN DO:
                            IF item.tipo-con-est = 3 THEN DO: /* Item Controlado por Lote */

                                LOG-MANAGER:WRITE-MESSAGE("1 INICIO Controle por lote: " + tt-rat-lote.lote, "EBOIN367") NO-ERROR.

                                ASSIGN l-transf-estabs = NO.                                                                                                                              

                                /* Transferencia entre estabs */                                
                                FOR FIRST estabelec FIELDS(cod-estabel) NO-LOCK
                                    WHERE estabelec.cod-emitente = b-docum-est.cod-emitente.                                        
                                
                                    LOG-MANAGER:WRITE-MESSAGE("2 Manteve Lote transf entre estabs: " + tt-rat-lote.lote, "EBOIN367") NO-ERROR.
                                                               
                                    ASSIGN tt-rat-lote.dt-vali-lote = date("31/12/9999")
                                           l-sugeriu-lote           = YES
                                           l-transf-estabs          = YES.
                                END.

                                /* Retorno de beneficiamento */
                                ASSIGN l-retorno = NO.

                                LOG-MANAGER:WRITE-MESSAGE("3 Natureza: " + tt-rat-lote.nat-operacao, "EBOIN367") NO-ERROR.                                

                                FIND FIRST natur-oper NO-LOCK 
                                     WHERE natur-oper.nat-operacao = tt-rat-lote.nat-operacao NO-ERROR.
                                IF AVAIL natur-oper THEN DO:
                                    IF natur-oper.terceiros AND natur-oper.tp-oper-terc = 2 THEN DO:
                                        ASSIGN tt-rat-lote.dt-vali-lote = date("31/12/9999")
                                               l-sugeriu-lote           = YES
                                               l-retorno                = YES.

                                        LOG-MANAGER:WRITE-MESSAGE("5 Manteve Lote retorno beneficiamento: " + tt-rat-lote.lote, "EBOIN367") NO-ERROR.
                                    END.
                                END.
                                                               
                                IF (NOT l-transf-estabs AND 
                                    NOT l-retorno) THEN DO:

                                    LOG-MANAGER:WRITE-MESSAGE("6 Lote generico", "EBOIN367") NO-ERROR.
                                    EMPTY TEMP-TABLE tt-prog-ponto.
                                    RUN esp/es0018p.p (INPUT "ALM-WMS":U,
                                                       INPUT 1,
                                                       INPUT 0,
                                                       INPUT "":U,
                                                       OUTPUT TABLE tt-prog-ponto).
                                    FIND FIRST tt-prog-ponto
                                         WHERE tt-prog-ponto.conteudo = b-docum-est.cod-estabel NO-ERROR.
                                    IF NOT AVAIL tt-prog-ponto THEN DO:
                                       ASSIGN tt-rat-lote.lote = "GENERICO"
                                              l-sugeriu-lote   = YES.
                                       
                                       ASSIGN tt-rat-lote.dt-vali-lote = date("31/12/9999")
                                              l-sugeriu-lote           = YES.
                                    END.
                                    ELSE DO:
                                       IF tt-rat-lote.lote = "" THEN
                                          ASSIGN tt-rat-lote.lote = "GENERICO"
                                                 l-sugeriu-lote   = YES.
                                       
                                       IF tt-rat-lote.dt-vali-lote  = ? THEN
                                          ASSIGN tt-rat-lote.dt-vali-lote = date("31/12/9999")
                                                 l-sugeriu-lote           = YES.
                                    
                                       IF tt-rat-lote.lote = "GENERICO" AND tt-rat-lote.dt-vali-lote <= TODAY  THEN
                                          ASSIGN tt-rat-lote.dt-vali-lote = date("31/12/9999")
                                                 l-sugeriu-lote           = YES.
                                    END.
                                END.                                                              
                            END.
                        END.
                    END.
                    
                    ASSIGN tt-rat-lote.cod-localiz = "".
                    RUN setrecord IN h_boin367 (INPUT TABLE tt-rat-lote).
                    /*--- Busca temptable RowErrors ---*/
                    run getRowErrors in h_boin367 ( output table tt-bo-erro ).
                
                    IF l-sugeriu-lote  = YES THEN DO:
                       FOR EACH tt-bo-erro
                          WHERE tt-bo-erro.cd-erro = 1818: /* Lote BRANCO */
                           DELETE tt-bo-erro.
                           ASSIGN l-atualiza = YES.
                       END.
                       
                       FOR EACH tt-bo-erro
                          WHERE tt-bo-erro.cd-erro = 1247: /* Validade do lote vencida */
                           DELETE tt-bo-erro.
                           ASSIGN l-atualiza = YES.
                       END.
                    END.
                
                    FOR EACH tt-bo-erro 
                        WHERE tt-bo-erro.cd-erro = 2:
                        IF  tt-bo-erro.mensagem MATCHES("*Localizaá∆o*") THEN DO:
                            DELETE tt-bo-erro.
                            ASSIGN l-atualiza = YES.
                        END.
                    END.
                    IF l-atualiza THEN DO:
                      /*--- Limpa temptable RowErrors ---*/
                      RUN emptyRowErrors in h_boin367.
                
                      FOR EACH tt-bo-erro:
                          /*--- Cria temptable RowErrors ---*/
                          RUN _insertError in h_boin367 (INPUT tt-bo-erro.cd-erro,
                                                         INPUT tt-bo-erro.errortype,
                                                         INPUT tt-bo-erro.errorsubtype,
                                                         INPUT tt-bo-erro.parametros).                        
                      END.
                
                    END.
                END.   
            END.
            DELETE tt-epc.
        end.
    END.
    //when 'aftercreateRecord' then do:
    when 'beforecreateRecord' then do:
        FOR FIRST tt-epc where tt-epc.cod-event = p-ind-event:
            IF  VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter))
            THEN DO:
                ASSIGN h_boin367 = WIDGET-HANDLE(tt-epc.val-parameter).
            
                RUN getrecord IN h_boin367 (OUTPUT TABLE tt-rat-lote).
                FIND FIRST tt-rat-lote NO-ERROR.
                IF AVAIL tt-rat-lote
                THEN DO:
                    //INI-Luciano Leonhardt
                    //Ignorar a geraá∆o do SKIP-LOTE para as especies cadastradas no ES0018.
                    FOR FIRST docum-est
                        WHERE docum-est.serie-docto  = tt-rat-lote.serie-docto
                          AND docum-est.nro-docto    = tt-rat-lote.nro-docto
                          AND docum-est.cod-emitente = tt-rat-lote.cod-emitente
                          AND docum-est.nat-operacao = tt-rat-lote.nat-operacao
                       NO-LOCK.
                        EMPTY TEMP-TABLE tt-prog-ponto.
                        RUN esp/es0018p.p (INPUT "re1001":U,
                                           INPUT 6,
                                           INPUT 1, //Esp-fical
                                           INPUT "":U,
                                           OUTPUT TABLE tt-prog-ponto).
                        FOR FIRST tt-prog-ponto NO-LOCK:
                            //Indica que o documento tem a especis que n∆o precisa gerar SKIP-LOTE.
                            IF INDEX(tt-prog-ponto.conteudo, docum-est.esp-fiscal) > 0
                            THEN DO:
                                RETURN "OK".
                            END.
                        END.
                    END.
                    //FIM-Luciano Leonhardt

                    DEFINE VARIABLE iLote AS INTEGER     NO-UNDO.

                    blk_leon:
                    FOR FIRST int-item-fornec NO-LOCK
                        WHERE int-item-fornec.it-codigo         = tt-rat-lote.it-codigo
                          AND int-item-fornec.cod-emitente      = 0.
                        ASSIGN  iLote = (int-item-fornec.ultimo-skip-lote + 1).

                        IF  iLote > int-item-fornec.num-lotes
                        THEN DO:
	                        FOR FIRST docum-est NO-LOCK
                                WHERE docum-est.serie-docto  = tt-rat-lote.serie-docto
                                  AND docum-est.nro-docto    = tt-rat-lote.nro-docto
                                  AND docum-est.cod-emitente = tt-rat-lote.cod-emitente
                                  AND docum-est.nat-operacao = tt-rat-lote.nat-operacao
                                .
                                FOR FIRST item-uni-estab NO-LOCK
                                    WHERE item-uni-estab.it-codigo   = tt-rat-lote.it-codigo
                                      AND item-uni-estab.cod-estabel = docum-est.cod-estabel:

                                    ASSIGN tt-rat-lote.cod-depos = item-uni-estab.deposito-pad.
                                    RUN setRecord       IN h_boin367 (INPUT TABLE tt-rat-lote).
                                    FIND FIRST item-doc-est EXCLUSIVE-LOCK
                                         WHERE item-doc-est.serie-docto  = tt-rat-lote.serie-docto
                                           AND item-doc-est.nro-docto    = tt-rat-lote.nro-docto
                                           AND item-doc-est.cod-emitente = tt-rat-lote.cod-emitente
                                           AND item-doc-est.nat-operacao = tt-rat-lote.nat-operacao
                                           AND item-doc-est.it-codigo    = tt-rat-lote.it-codigo NO-ERROR.
                                    IF AVAIL item-doc-est THEN
                                       ASSIGN item-doc-est.cod-depos = item-uni-estab.deposito-pad.

                                    RELEASE item-doc-est.
                                        
                                END.
                            END.
                        END.
                        ELSE DO:
                            FIND CURRENT int-item-fornec EXCLUSIVE-LOCK NO-ERROR.
                            ASSIGN int-item-fornec.ultimo-skip-lote = iLote.
                            FIND CURRENT int-item-fornec NO-LOCK NO-ERROR.
    
                            IF NOT CAN-FIND(FIRST int-item-fornec-skip-lote  NO-LOCK
                                            WHERE int-item-fornec-skip-lote.it-codigo       = tt-rat-lote.it-codigo
                                              AND int-item-fornec-skip-lote.cod-emitente    = 0)
                            THEN DO:
                                RUN utp/ut-msgs.p (INPUT "SHOW",
                                                   INPUT 17006,
                                                   INPUT "Movimentaá∆o n∆o Permitida!~~Para movimentar este item Ç necess†rio configurar o sequenciamento do Skipt-Lote no programa esp/cqp/escqp015.w. Verifique!").
                                RETURN "NOK".
                            END.
    
                            FOR  EACH int-item-fornec-skip-lote  NO-LOCK
                                WHERE int-item-fornec-skip-lote.it-codigo       = tt-rat-lote.it-codigo
                                  AND int-item-fornec-skip-lote.cod-emitente    = 0
                                  AND int-item-fornec-skip-lote.sequencia       = iLote:
    
                                FIND FIRST item-doc-est
                                     WHERE item-doc-est.serie-docto  = tt-rat-lote.serie-docto
                                       AND item-doc-est.nro-docto    = tt-rat-lote.nro-docto
                                       AND item-doc-est.cod-emitente = tt-rat-lote.cod-emitente
                                       AND item-doc-est.nat-operacao = tt-rat-lote.nat-operacao
                                       AND item-doc-est.it-codigo    = tt-rat-lote.it-codigo
                                    NO-LOCK NO-ERROR.
                                IF AVAIL item-doc-est
                                THEN DO:
                                    FIND FIRST pedido-compr
                                         WHERE pedido-compr.num-pedido = item-doc-est.num-pedido
                                        NO-LOCK NO-ERROR.
                                END.
    
                                IF AVAIL pedido-compr
                                AND pedido-compr.log-1 = YES
                                THEN DO:
                                    ASSIGN  tt-rat-lote.int-1   = iLote
                                            tt-rat-lote.char-1  = STRING(item-doc-est.num-pedido).
    
                                    RUN setRecord IN h_boin367 (INPUT TABLE tt-rat-lote).
                                END.
                                ELSE DO:
                                    IF  NOT int-item-fornec-skip-lote.log-analisa-lote
                                    THEN DO:
                                        FOR FIRST docum-est NO-LOCK
                                            WHERE docum-est.serie-docto  = tt-rat-lote.serie-docto
                                              AND docum-est.nro-docto    = tt-rat-lote.nro-docto
                                              AND docum-est.cod-emitente = tt-rat-lote.cod-emitente
                                              AND docum-est.nat-operacao = tt-rat-lote.nat-operacao
                                            .
                                            FOR FIRST item-uni-estab NO-LOCK
                                                WHERE item-uni-estab.it-codigo   = tt-rat-lote.it-codigo
                                                  AND item-uni-estab.cod-estabel = docum-est.cod-estabel:
            
                                                ASSIGN tt-rat-lote.cod-depos = item-uni-estab.deposito-pad.
                                                RUN setRecord       IN h_boin367 (INPUT TABLE tt-rat-lote).
                                                FIND FIRST item-doc-est EXCLUSIVE-LOCK
                                                     WHERE item-doc-est.serie-docto  = tt-rat-lote.serie-docto
                                                       AND item-doc-est.nro-docto    = tt-rat-lote.nro-docto
                                                       AND item-doc-est.cod-emitente = tt-rat-lote.cod-emitente
                                                       AND item-doc-est.nat-operacao = tt-rat-lote.nat-operacao
                                                       AND item-doc-est.it-codigo    = tt-rat-lote.it-codigo NO-ERROR.
                                                IF AVAIL item-doc-est THEN
                                                   ASSIGN item-doc-est.cod-depos = item-uni-estab.deposito-pad.
                                                
                                                RELEASE item-doc-est.
                                            END.
                                        END.
                                    END.
                                    ELSE DO:
                                        ASSIGN tt-rat-lote.int-1     = iLote.
                                        RUN setRecord IN h_boin367 (INPUT TABLE tt-rat-lote).
                                    END.
                                END.
                            END.
                        END.
                    END. //blk_leon:
                END.
            END.
        END.
    END.
END.

/* Fim do programa EPC */


