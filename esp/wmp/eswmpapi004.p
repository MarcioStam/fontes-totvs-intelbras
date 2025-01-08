/********************************************************************************
**
** PROAGRAMA: ESWMPAPI004 - API Eliminacao Documento WMS Integracao FT
** 
**
**
*******************************************************************************/
{method/dbotterr.i}
{utp/ut-glob.i}

PROCEDURE piVerifica:
    
    DEF INPUT  PARAM p-rowid-nf      AS ROWID NO-UNDO.
    DEF OUTPUT PARAM TABLE           FOR RowErrors.

    DEF BUFFER bfwm-docto            FOR wm-docto.

    FIND FIRST nota-fiscal WHERE
        ROWID(nota-fiscal) = p-rowid-nf NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:

        FOR EACH it-pre-fat WHERE
            it-pre-fat.cdd-embarq  = nota-fiscal.cdd-embarq  AND
            it-pre-fat.nr-embarque = nota-fiscal.nr-embarque AND
            it-pre-fat.nr-resumo   = nota-fiscal.nr-resumo   NO-LOCK:

            FOR EACH wm-local WHERE
                wm-local.cod-estabel = nota-fiscal.cod-estabel NO-LOCK:
                
                FIND FIRST transporte WHERE
                    transporte.nome-abrev = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
                FIND FIRST int-transporte WHERE
                    int-transporte.cod-trans = transporte.cod-trans NO-LOCK NO-ERROR.
                IF AVAIL int-transporte AND int-transporte.separa-uf = YES THEN DO:
                    FIND FIRST wm-docto WHERE
                        wm-docto.cod-estabel      = wm-local.cod-estabel                                      AND
                        wm-docto.cod-local        = wm-local.cod-local                                        AND
                        wm-docto.num-docto        = STRING(it-pre-fat.cdd-embarq ) + "-" + nota-fiscal.estado AND
                        wm-docto.ind-origem-docto = 5                                                         NO-LOCK NO-ERROR.
                END.
                ELSE DO:
                    FIND FIRST wm-docto WHERE
                        wm-docto.cod-estabel      = wm-local.cod-estabel           AND
                        wm-docto.cod-local        = wm-local.cod-local             AND
                        wm-docto.num-docto        = STRING(it-pre-fat.cdd-embarq ) AND
                        wm-docto.ind-origem-docto = 5                              NO-LOCK NO-ERROR.
                END.
            
                IF AVAIL wm-docto THEN DO:
                    
                    IF wm-docto.ind-sit = 1 THEN DO:
                       IF CAN-FIND(FIRST wm-docto-itens OF wm-docto WHERE
                                wm-docto-itens.ind-sit <> 1 NO-LOCK) THEN DO:
                            RUN piCreateError IN THIS-PROCEDURE (INPUT 17006,
                                                                 INPUT 'Nota Fiscal ja em processo de separaá∆o no WMS. Favor entrar em contato com a Expediá∆o.~~~~Nota Fiscal n∆o pode ser cancelada',
                                                                 INPUT 'EMS':U,
                                                                 INPUT 'ERROR':U).
                            RETURN "NOK":U.
                        END.
                    END.
                END.

                /* Docto Fracionado */
                FIND FIRST bfwm-docto WHERE
                    bfwm-docto.cod-estabel      = wm-local.cod-estabel                     AND
                    bfwm-docto.cod-local        = wm-local.cod-local                       AND
                    bfwm-docto.num-docto        = STRING(it-pre-fat.cdd-embarq ) + "-FRAC" AND
                    bfwm-docto.ind-origem-docto = 5                                        NO-LOCK NO-ERROR.
                IF AVAIL bfwm-docto THEN DO:
                    IF bfwm-docto.ind-sit = 1 THEN DO:
                        IF CAN-FIND(FIRST wm-docto-itens OF bfwm-docto WHERE
                            wm-docto-itens.ind-sit <> 1 NO-LOCK) THEN DO:
                            RUN piCreateError IN THIS-PROCEDURE (INPUT 17006,
                                                                 INPUT 'Nota Fiscal (Fracionado) ja em processo de separaá∆o no WMS. Favor entrar em contato com a Expediá∆o~~~~Nota Fiscal n∆o pode ser cancelada',
                                                                 INPUT 'EMS':U,
                                                                 INPUT 'ERROR':U).
                            RETURN "NOK":U.
                        END.
                    END.
                END.
                
            END.
        END.
    END.
    ELSE DO:
        RUN piCreateError IN THIS-PROCEDURE (INPUT 56,
                                             INPUT 'Nota Fiscal',
                                             INPUT 'EMS':U,
                                             INPUT 'ERROR':U).
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piDesatualizaWMS:

    DEF INPUT  PARAM p-rowid-nf      AS ROWID NO-UNDO.
    DEF OUTPUT PARAM TABLE           FOR RowErrors.

    DEF VAR d-qtd-item-aux           LIKE wm-docto-itens.qtd-item NO-UNDO.
    DEF VAR d-qtd-movto              LIKE wm-box-movto.qtd-item   NO-UNDO.
        
    DEF BUFFER bfwm-docto            FOR wm-docto.
    DEF BUFFER bfWm-docto-itens      FOR wm-docto-itens.
    DEF VAR i-num-seq-item           LIKE wm-docto-itens.num-seq-item   NO-UNDO.
    DEF VAR hDBOsc039                AS HANDLE                          NO-UNDO.

    FIND FIRST nota-fiscal WHERE
        ROWID(nota-fiscal) = p-rowid-nf NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:

        FOR EACH integra-mft-wms-notas WHERE
            integra-mft-wms-notas.cod-estabel = nota-fiscal.cod-estabel AND
            integra-mft-wms-notas.serie       = nota-fiscal.serie       AND
            integra-mft-wms-notas.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK:

            ASSIGN d-qtd-item-aux = integra-mft-wms-notas.qtd-integra.

            FOR EACH wm-docto USE-INDEX idx-docto5 WHERE
                wm-docto.cod-estabel      = integra-mft-wms-notas.cod-estabel AND
                wm-docto.num-docto        = integra-mft-wms-notas.cod-integra AND
                wm-docto.ind-origem-docto = 5                                 EXCLUSIVE-LOCK:
    
                IF wm-docto.ind-sit-docto = 1 THEN DO:
                    FOR EACH wm-docto-itens OF wm-docto WHERE
                        wm-docto-itens.cod-item =  integra-mft-wms-notas.it-codigo EXCLUSIVE-LOCK:
        
                        FOR EACH wm-box-movto OF wm-docto-itens WHERE 
                            wm-box-movto.ind-tipo-movto = 2 AND 
                            wm-box-movto.ind-status     = 1 NO-LOCK:
                            RUN wmp/wm9022.p (INPUT  ROWID(wm-box-movto),
                                              OUTPUT TABLE RowErrors).
                        END.
        
                        ASSIGN d-qtd-movto = 0.
                        FOR EACH wm-box-movto OF wm-docto-itens WHERE 
                            wm-box-movto.ind-tipo-movto = 2 NO-LOCK:
                            ASSIGN d-qtd-movto = d-qtd-movto + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                        END.

                        IF wm-docto-itens.qtd-item - d-qtd-movto > d-qtd-item-aux THEN DO:
                            ASSIGN wm-docto-itens.qtd-item = wm-docto-itens.qtd-item - d-qtd-item-aux
                                   d-qtd-item-aux          = 0. 
        
                            RUN wmp/wm9020.p (INPUT wm-docto-itens.qtd-item,
                                              INPUT ROWID(wm-docto-itens),
                                              OUTPUT TABLE RowErrors).
                            
                        END.
                        ELSE DO:
                            ASSIGN d-qtd-item-aux = d-qtd-item-aux - (wm-docto-itens.qtd-item - d-qtd-movto).
                            IF NOT CAN-FIND(FIRST wm-box-movto OF wm-docto-itens NO-LOCK) THEN
                                DELETE wm-docto-itens.
                            
                        END.
        
                        IF d-qtd-item-aux <= 0 THEN
                            LEAVE.
        
                    END.
    
                    IF NOT CAN-FIND(FIRST wm-docto-itens OF wm-docto NO-LOCK) THEN
                        DELETE wm-docto.
                END.
                ELSE DO:

                    FIND FIRST bfWm-docto WHERE
                        bfWm-docto.cod-estabel      = wm-docto.cod-estabel    AND
                        bfWm-docto.cod-local        = wm-docto.cod-local      AND
                        bfWm-docto.num-docto        = nota-fiscal.nr-nota-fis AND
                        bfWm-docto.ind-origem-docto = 10                      EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAIL bfWm-docto THEN DO:
                        CREATE bfWm-docto.
                        ASSIGN bfWm-docto.cod-estabel      = wm-docto.cod-estabel      
                               bfWm-docto.cod-local        = wm-docto.cod-local       
                               bfWm-docto.cod-usuario      = c-seg-usuario     
                               bfWm-docto.dt-implan-docto  = TODAY
                               bfWm-docto.id-docto         = NEXT-VALUE(id-docto-wms)
                               bfWm-docto.ind-origem-docto = 10
                               bfWm-docto.ind-sit-docto    = 1   
                               bfWm-docto.ind-tipo-trans   = 1  
                               bfWm-docto.num-docto        = nota-fiscal.nr-nota-fis       
                               bfWm-docto.num-docto-origem = wm-docto.num-docto-origem
                               i-num-seq-item              = 0.
                    END.
                    ELSE DO:
                        ASSIGN bfWm-docto.ind-sit = 1.
                        FOR LAST bfWm-docto-itens OF bfWm-docto NO-LOCK
                            BY bfWm-docto-itens.num-seq-item:
                            ASSIGN i-num-seq-item = bfWm-docto-itens.num-seq-item.
                        END.
                    END.

                    FOR EACH wm-docto-itens OF wm-docto WHERE
                        wm-docto-itens.cod-item = integra-mft-wms-notas.it-codigo NO-LOCK:
                    
                        ASSIGN i-num-seq-item = i-num-seq-item + 10.

                        CREATE bfWm-docto-itens.
                        BUFFER-COPY wm-docto-itens EXCEPT id-docto num-seq-item TO bfWm-docto-itens.
                        ASSIGN bfWm-docto-itens.num-seq-item = i-num-seq-item
                               bfWm-docto-itens.ind-sit      = 1
                               bfWm-docto-itens.id-docto     = bfWm-docto.id-docto
                               bfWm-docto-itens.num-seq-orig = bfWm-docto-itens.num-seq-item
                               bfWm-docto-itens.qtd-item     = d-qtd-item-aux.

                        IF  NOT VALID-HANDLE(hDBOsc039) THEN
                            RUN scbo/bosc039.p PERSISTENT SET hDBOsc039.
                        RUN SugestaoAlocacaoItem IN hDBOsc039 (INPUT bfWm-docto.cod-estabel,
                                                               INPUT bfWm-docto.cod-local,
                                                               INPUT bfWm-docto.id-docto,
                                                               INPUT bfWm-docto-itens.num-seq-item ).                
                        ASSIGN d-qtd-item-aux = 0.
                        LEAVE.
                        
                    END.

                END.
            END.

            IF d-qtd-item-aux > 0 THEN DO:

                RUN piCreateError IN THIS-PROCEDURE (INPUT 17006,
                                                     INPUT "Houveram ERROS no WMS para Desatualizacao da Nota Fiscal",
                                                     INPUT 'EMS':U,
                                                     INPUT 'ERROR':U).
                UNDO, RETURN "NOK":U.
            END.

        END.

    END.
    ELSE DO:

        RUN piCreateError IN THIS-PROCEDURE (INPUT 56,
                                             INPUT "Nota Fiscal",
                                             INPUT 'EMS':U,
                                             INPUT 'ERROR':U).
        RETURN "NOK":U.
    END.


    RETURN "OK":U.

END PROCEDURE.


PROCEDURE piEliminaDocto:

    DEFINE INPUT PARAMETER p-cod-estabel    LIKE wm-docto.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-local      LIKE wm-docto.cod-local   NO-UNDO.
    DEFINE INPUT PARAMETER p-id-docto       LIKE wm-docto.id-docto    NO-UNDO.  
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    FIND FIRST wm-docto NO-LOCK
         WHERE wm-docto.cod-estabel = p-cod-estabel
           AND wm-docto.cod-local   = p-cod-local 
           AND wm-docto.id-docto    = p-id-docto NO-ERROR.
    IF NOT AVAIL wm-docto THEN DO:
        RUN piCreateError IN THIS-PROCEDURE (INPUT 56,
                                             INPUT 'Documento WMS',
                                             INPUT 'EMS':U,
                                             INPUT 'ERROR':U).
        RETURN "OK":U.
    END.
    
    IF wm-docto.ind-origem-docto <> 5 THEN DO:
        RUN piCreateError IN THIS-PROCEDURE (INPUT 17006,
                                             INPUT "Documento WMS n∆o tem Origem Pedido",
                                             INPUT 'EMS':U,
                                             INPUT 'ERROR':U).
        RETURN "OK":U.
    END.
    
    IF wm-docto.ind-sit-docto = 2 THEN DO:
        RUN piCreateError IN THIS-PROCEDURE (INPUT 17006,              
                                             INPUT "Documento WMS ja se encontra Concluido",
                                             INPUT 'EMS':U,
                                             INPUT 'ERROR':U).
        RETURN "OK":U.
    END.
    
    IF CAN-FIND(FIRST wm-docto-itens OF wm-docto WHERE 
                wm-docto-itens.ind-sit-movto = 2 NO-LOCK) THEN DO:
        RUN piCreateError IN THIS-PROCEDURE (INPUT 17006,              
                                             INPUT "Ja existem Itens com sequencias separadas no Documento",
                                             INPUT 'EMS':U,
                                             INPUT 'ERROR':U).
        RETURN "OK":U.
    END.
    
    Bloco:
    FOR EACH wm-docto-itens OF wm-docto EXCLUSIVE-LOCK:
    
        FOR EACH wm-box-movto OF wm-docto-itens WHERE 
            wm-box-movto.ind-status     = 1 AND
            wm-box-movto.ind-tipo-movto = 2 NO-LOCK:
            RUN wmp/wm9022.p (INPUT ROWID(wm-box-movto),
                              OUTPUT TABLE RowErrors).
            IF RETURN-VALUE <> "OK":U THEN
                UNDO Bloco, RETURN "NOK":U.
        END.
    
        IF CAN-FIND(FIRST wm-box-movto OF wm-docto-itens NO-LOCK) THEN DO:
            RUN piCreateError IN THIS-PROCEDURE (INPUT 17006,              
                                                 INPUT "Ja existem Itens com sequencias separadas no Documento",
                                                 INPUT 'EMS':U,
                                                 INPUT 'ERROR':U).
            UNDO Bloco, RETURN "NOK":U.
        END.
    
        FOR EACH wm-docto-itens-ped OF wm-docto-itens EXCLUSIVE-LOCK:
            DELETE wm-docto-itens-ped.
        END.

        FIND FIRST wm-local OF wm-docto-itens NO-LOCK NO-ERROR.
        FIND FIRST saldo-estoq WHERE
            saldo-estoq.cod-estabel = wm-docto-itens.cod-estabel                                                AND
            saldo-estoq.cod-depos   = (IF AVAIL wm-local THEN wm-local.cod-depos ELSE wm-docto-itens.cod-local) AND
            saldo-estoq.cod-localiz = ""                                                                        AND
            saldo-estoq.it-codigo   = wm-docto-itens.cod-item                                                   AND
            saldo-estoq.cod-refer   = wm-docto-itens.cod-refer                                                  AND
            saldo-estoq.lote        = wm-docto-itens.cod-lote                                                   EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL saldo-estoq THEN DO:
            ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod - wm-docto-itens.qtd-item.
            IF saldo-estoq.qt-aloc-prod < 0 THEN
                ASSIGN saldo-estoq.qt-aloc-prod = 0.
        END.
        FIND CURRENT saldo-estoq NO-LOCK NO-ERROR.
    
        DELETE wm-docto-itens.
    END.
    
    FIND CURRENT wm-docto EXCLUSIVE-LOCK NO-ERROR.
    DELETE wm-docto.
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piCreateError:

    DEFINE INPUT PARAMETER pErrorNumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

    FIND LAST RowErrors NO-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).  

    FIND FIRST RowErrors
         WHERE RowErrors.ErrorDescription = RETURN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAIL RowErrors THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = i-sequencia
               RowErrors.ErrorNumber      = pErrorNumber
               RowErrors.ErrorParameters  = pErrorParameters
               RowErrors.ErrorType        = pErrorType
               RowErrors.ErrorSubType     = pErrorSubType
               RowErrors.ErrorDescription = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).  
        ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.
    END.

    RETURN "OK":U.    

END PROCEDURE.


