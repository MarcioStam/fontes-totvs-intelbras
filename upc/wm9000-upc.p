/********************************************************************************
**  Programa: WM9000-UPC.P                                                     **
**  Data....: Marco de 2015                                                    **
**  Autor...: SCM Concept Tecnologia da Inf Ltda                               **
**  Objetivo: Tratamento Devolucao para Faturamento Antecipado.                **
**                                                                             **
********************************************************************************/
{include/i-epc200.i} /* Definicao tt-epc            */
{METHOD/dbotterr.i}
{esp/es0018.i}

/* Definicao de Parametros */
DEFINE INPUT        PARAMETER p-ind-event AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

DEF BUFFER bfWm-docto       FOR wm-docto.

DEF VAR h-wm-docto         AS HANDLE    NO-UNDO.
DEF VAR h-buffer           AS HANDLE    NO-UNDO.
DEF VAR h-query            AS HANDLE    NO-UNDO.
DEF VAR h-wm-docto-itens   AS HANDLE    NO-UNDO.
DEF VAR h-buffer-itens     AS HANDLE    NO-UNDO.
DEF VAR h-buffer-item           AS HANDLE    NO-UNDO.
DEF VAR h-query-item            AS HANDLE    NO-UNDO.
DEF VAR h-query-itens      AS HANDLE    NO-UNDO.
DEF VAR h-ind-origem-docto AS HANDLE    NO-UNDO.
DEF VAR h-num-docto-origem AS HANDLE    NO-UNDO.
DEF VAR h-cod-estabel      AS HANDLE    NO-UNDO.
DEF VAR h-cod-local        AS HANDLE    NO-UNDO.
DEF VAR h-cod-depos        AS HANDLE    NO-UNDO.
DEF VAR h-cod-item         AS HANDLE    NO-UNDO.
DEF VAR h-cod-local-item   AS HANDLE    NO-UNDO.
DEF VAR h-serie            AS HANDLE    NO-UNDO.
DEF VAR h-gera-sugestao    AS HANDLE    NO-UNDO.
DEF VAR h-num-docto        AS HANDLE    NO-UNDO.
DEF VAR h-ind-tipo-trans   AS HANDLE    NO-UNDO.
DEF VAR l-processo         AS LOGICAL   NO-UNDO.

DEF VAR c-tipo             AS CHAR      NO-UNDO.
DEF VAR c-transp           AS CHAR      NO-UNDO.
DEF VAR l-sem-integracao   AS LOGICAL   NO-UNDO.
DEF VAR l-com-integracao   AS LOGICAL   NO-UNDO.

IF p-ind-event = "afterCreateDocto" THEN  DO:

    FIND FIRST tt-epc
         WHERE tt-epc.cod-event = "afterCreateDocto":U NO-LOCK NO-ERROR.

    IF  p-ind-event = "afterCreateDocto":U AND
        AVAIL tt-epc                       THEN DO:

        FOR EACH RowErrors:
                DELETE RowErrors.
        END.

        FIND FIRST wm-docto NO-LOCK
             WHERE ROWID(wm-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.

        /* Recebimento - Nota Devolucao */
        IF AVAIL wm-docto AND wm-docto.ind-origem-docto = 3 THEN DO:

            FOR EACH devol-cli WHERE
                     devol-cli.serie-docto  = SUBSTRING(wm-docto.num-docto-origem,01,05)      AND  
                     devol-cli.nro-docto    = SUBSTRING(wm-docto.num-docto-origem,06,16)      AND
                     devol-cli.cod-emitente = INT(SUBSTRING(wm-docto.num-docto-origem,22,09)) AND
                     devol-cli.nat-operacao = SUBSTRING(wm-docto.num-docto-origem,31,10)      NO-LOCK:

                FIND FIRST nota-fiscal WHERE
                    nota-fiscal.cod-estabel = devol-cli.cod-estabel AND
                    nota-fiscal.serie       = devol-cli.serie       AND
                    nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis NO-LOCK NO-ERROR.

                RUN esp/es0018p.p (INPUT "WM0260", /* Nome do programa */
                                   INPUT 1,        /* Ponto do programa */
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto).

                FIND FIRST tt-prog-ponto NO-LOCK
                    WHERE ENTRY(1, tt-prog-ponto.conteudo,",") = (IF AVAIL nota-fiscal THEN nota-fiscal.cod-estabel ELSE "") NO-ERROR.

                IF AVAIL nota-fiscal AND (AVAIL tt-prog-ponto AND date(ENTRY(2, tt-prog-ponto.conteudo,",")) <= nota-fiscal.dt-emis-nota) THEN DO:
                
                    IF NOT CAN-FIND(FIRST integra-mft-wms-notas WHERE 
                                    integra-mft-wms-notas.cod-estabel = nota-fiscal.cod-estabel AND
                                    integra-mft-wms-notas.serie       = nota-fiscal.serie       AND
                                    integra-mft-wms-notas.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK) THEN DO:
                        
                        FOR EACH wm-docto-itens OF wm-docto EXCLUSIVE-LOCK:
                            FOR EACH wm-box-movto OF wm-docto-itens WHERE
                                wm-box-movto.ind-tipo-movto = 1 NO-LOCK:
                                RUN wmp/wm9032.p (INPUT  ROWID(wm-box-movto),
                                                  OUTPUT TABLE RowErrors).
                            END.
                            IF NOT CAN-FIND(FIRST wm-box-movto OF wm-docto-itens) THEN DO:
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
                                DELETE wm-docto-itens.
                            END.
                        END.

                        /* Eliminar a tabela de controle de saldo de nota n∆o integrada com WMS */
                        FOR EACH int-wms-nf-atualiz EXCLUSIVE-LOCK
                            WHERE int-wms-nf-atualiz.cod-estabel = nota-fiscal.cod-estabel
                              and int-wms-nf-atualiz.serie       = nota-fiscal.serie      
                              and int-wms-nf-atualiz.nr-nota-fis = nota-fiscal.nr-nota-fis:
                             DELETE int-wms-nf-atualiz.
                        END.

                        IF NOT CAN-FIND(FIRST wm-docto-itens OF wm-docto NO-LOCK) THEN DO:
                            FIND CURRENT wm-docto EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL wm-docto THEN
                                DELETE wm-docto.
                            
                        END.

                    END.
                    
                END.

            END.

        END.
        /* Pedidos */
        ELSE IF AVAIL wm-docto AND wm-docto.ind-origem-docto = 5 THEN DO:

            ASSIGN c-tipo   = ENTRY(2,wm-docto.num-docto,"-") NO-ERROR.
            ASSIGN c-transp = ENTRY(2,wm-docto.num-docto-origem,"|") NO-ERROR.

            /* Atribuicao DOCA de acordo Transportadora */
            FIND FIRST wm-doca WHERE
                SUBSTRING(wm-doca.char-2,110,20) = c-transp NO-LOCK NO-ERROR.
            IF AVAIL wm-doca THEN DO:
                
                FOR EACH bfWm-docto WHERE 
                    bfWm-docto.cod-estabel      = wm-docto.cod-estabel                   AND 
                    bfWm-docto.cod-local        = wm-docto.cod-local                     AND 
                    bfWm-docto.ind-origem-docto = 5                                      AND
                    bfWm-docto.num-docto   BEGINS ENTRY(1,wm-docto.num-docto,"-") EXCLUSIVE-LOCK:

                    ASSIGN bfWm-docto.cod-doca = wm-doca.cod-doca.
                    
                    FOR EACH wm-docto-itens OF bfwm-docto EXCLUSIVE-LOCK:
                        ASSIGN wm-docto-itens.cod-doca = wm-doca.cod-doca.
                        
                        FOR EACH wm-box-movto OF wm-docto-itens WHERE 
                            wm-box-movto.ind-tipo-movto = 1 EXCLUSIVE-LOCK:
                            ASSIGN wm-box-movto.id-box = wm-doca.id-box.
                        END.
        
                    END.
                END.
            END.

        END.

    END.
END.


IF p-ind-event = "initialize" THEN DO:

    FIND FIRST tt-epc NO-LOCK
         WHERE tt-epc.cod-event     = p-ind-event
           AND tt-epc.cod-parameter = "handle-ttWm-docto" NO-ERROR.
    IF AVAIL tt-epc THEN DO:

        ASSIGN h-wm-docto = WIDGET-HANDLE(tt-epc.val-parameter) 
               h-buffer   = h-wm-docto:DEFAULT-BUFFER-HANDLE NO-ERROR.

        CREATE QUERY h-query.
        h-query:SET-BUFFERS(h-buffer).
        h-query:QUERY-PREPARE('for each ' + h-wm-docto:NAME).
        h-query:QUERY-OPEN().

        REPEAT ON ERROR UNDO,LEAVE:
            h-query:GET-NEXT().
            IF h-query:QUERY-OFF-END THEN LEAVE.

            IF h-wm-docto:HAS-RECORDS THEN DO:
                ASSIGN h-num-docto        = h-buffer:BUFFER-FIELD('num-docto')
                       h-ind-origem-docto = h-buffer:BUFFER-FIELD('ind-origem-docto')
                       h-num-docto-origem = h-buffer:BUFFER-FIELD('num-docto-origem')
                       h-cod-estabel      = h-buffer:BUFFER-FIELD('cod-estabel')
                       h-cod-local        = h-buffer:BUFFER-FIELD('cod-local')
                       h-serie            = h-buffer:BUFFER-FIELD('serie')
                       h-cod-depos        = h-buffer:BUFFER-FIELD('cod-depos')
                       h-ind-tipo-trans   = h-buffer:BUFFER-FIELD('ind-tipo-trans').

                IF h-ind-tipo-trans:BUFFER-VALUE = 1 THEN DO:
                    /**********/
                    //Logica para tratar mais de um LOCAL padr∆o com deposito CQ.
                    /**********/
                    FIND FIRST tt-epc NO-LOCK
                         WHERE tt-epc.cod-event     = p-ind-event
                           AND tt-epc.cod-parameter = "handle-ttWm-docto-itens" NO-ERROR.
                    IF AVAIL tt-epc THEN DO:
    
                        ASSIGN h-wm-docto-itens = WIDGET-HANDLE(tt-epc.val-parameter) 
                               h-buffer-item   = h-wm-docto-itens:DEFAULT-BUFFER-HANDLE NO-ERROR.
    
                        CREATE QUERY h-query-item.
                        h-query-item:SET-BUFFERS(h-buffer-item).
                        h-query-item:QUERY-PREPARE('for each ' + h-wm-docto-itens:NAME).
                        h-query-item:QUERY-OPEN().
    
                        REPEAT ON ERROR UNDO,LEAVE:
                            h-query-item:GET-NEXT().
                            IF h-query-item:QUERY-OFF-END THEN LEAVE.
    
                            IF h-wm-docto-itens:HAS-RECORDS THEN DO:
    
                                ASSIGN h-cod-item       = h-buffer-item:BUFFER-FIELD('cod-item')
                                       h-cod-local-item = h-buffer-item:BUFFER-FIELD('cod-local').
    
                                FOR  FIRST item-uni-estab NO-LOCK
                                     WHERE item-uni-estab.cod-estabel   = h-cod-estabel:BUFFER-VALUE
                                       AND item-uni-estab.it-codigo     = h-cod-item:BUFFER-VALUE:
    
                                    FOR FIRST wm-local-deposito NO-LOCK 
                                        WHERE wm-local-deposito.cod-estabel = h-cod-estabel:BUFFER-VALUE
                                          AND wm-local-deposito.cod-local   = item-uni-estab.deposito-pad:
                                        IF h-cod-depos:BUFFER-VALUE = wm-local-deposito.cod-deposito //REC
                                        THEN DO:
                                            ASSIGN h-cod-local      :BUFFER-VALUE = wm-local-deposito.cod-local
                                                   h-cod-local-item :BUFFER-VALUE = wm-local-deposito.cod-local.
                                        END.
                                    END.
                                END.
                            END.
                        END.
                    END.
                    /**********/
                END.

                IF h-ind-origem-docto:BUFFER-VALUE = 03 THEN DO: 
                    
                    /* Sem Sugestao */
                    FIND FIRST wm-local WHERE
                        wm-local.cod-estabel = h-cod-estabel:BUFFER-VALUE AND
                        wm-local.cod-local   = h-cod-local:BUFFER-VALUE   NO-LOCK NO-ERROR.
                    IF AVAIL wm-local AND wm-local.log-2 = YES THEN DO:
                        FIND FIRST tt-epc no-lock
                             WHERE tt-epc.cod-event     = p-ind-event
                               AND tt-epc.cod-parameter = "handle-ttWm-docto-itens" NO-ERROR.
                        IF AVAIL tt-epc THEN DO:
                            ASSIGN h-wm-docto-itens = WIDGET-HANDLE(tt-epc.val-parameter) 
                                   h-buffer-itens   = h-wm-docto-itens:DEFAULT-BUFFER-HANDLE NO-ERROR.
                        
                            CREATE QUERY h-query-itens.
                            h-query-itens:SET-BUFFERS(h-buffer-itens).
                            h-query-itens:QUERY-PREPARE('for each ' + h-wm-docto-itens:NAME).
                            h-query-itens:QUERY-OPEN().
                        
                            REPEAT ON ERROR UNDO,LEAVE:
                                h-query-itens:GET-NEXT().
                                IF h-query-itens:QUERY-OFF-END THEN LEAVE.
                        
                                IF h-wm-docto-itens:HAS-RECORDS THEN DO:
                                    ASSIGN h-gera-sugestao = h-buffer-itens:BUFFER-FIELD('gera-sugestao').
                                           h-gera-sugestao:BUFFER-VALUE = NO.   
                                END.
                            END.
                        END.
                    END.

                    ASSIGN l-sem-integracao = NO
                           l-com-integracao = NO.

                    FOR EACH devol-cli WHERE
                         devol-cli.serie-docto  = SUBSTRING(h-num-docto-origem:BUFFER-VALUE,01,05)      AND  
                         devol-cli.nro-docto    = SUBSTRING(h-num-docto-origem:BUFFER-VALUE,06,16)      AND
                         devol-cli.cod-emitente = INT(SUBSTRING(h-num-docto-origem:BUFFER-VALUE,22,09)) AND
                         devol-cli.nat-operacao = SUBSTRING(h-num-docto-origem:BUFFER-VALUE,31,10)      NO-LOCK:
                        
                        FIND FIRST nota-fiscal WHERE
                            nota-fiscal.cod-estabel = devol-cli.cod-estabel AND
                            nota-fiscal.serie       = devol-cli.serie       AND
                            nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis NO-LOCK NO-ERROR.

                        
                        RUN esp/es0018p.p (INPUT "WM0260", /* Nome do programa */
                            INPUT 1,        /* Ponto do programa */
                            INPUT 0,
                            INPUT "",
                            OUTPUT TABLE tt-prog-ponto).

                        FIND FIRST tt-prog-ponto NO-LOCK
                            WHERE ENTRY(1, tt-prog-ponto.conteudo,",") = (IF AVAIL nota-fiscal THEN nota-fiscal.cod-estabel ELSE "") NO-ERROR.

                        IF AVAIL nota-fiscal AND (AVAIL tt-prog-ponto AND date(ENTRY(2, tt-prog-ponto.conteudo,",")) <= nota-fiscal.dt-emis-nota) THEN DO:

                            /* Valida de NF Devol esta com NF Integrada e N∆o Integrada ao WMS */
                            IF NOT CAN-FIND(FIRST integra-mft-wms-notas WHERE
                                 integra-mft-wms-notas.cod-estabel = devol-cli.cod-estabel AND
                                 integra-mft-wms-notas.serie       = devol-cli.serie       AND
                                 integra-mft-wms-notas.nr-nota-fis = devol-cli.nr-nota-fis NO-LOCK) THEN
                                ASSIGN l-sem-integracao = YES.
                            ELSE
                                ASSIGN l-com-integracao = YES.
                            
                            IF l-sem-integracao = YES AND l-com-integracao = YES THEN DO:
                                RUN piCreateError (INPUT "Documento de Devoluá∆o com Notas Integradas e Notas N∆o Integradas com o WMS. Documento dever† ser desmembrado.").
                                RETURN "NOK":U.
                            END.
                            
                            /* Valida se NF Integradas j† est∆o 100% Separadas */
                            IF l-sem-integracao = NO THEN DO:
                                FOR EACH it-pre-fat WHERE
                                    it-pre-fat.cdd-embarq  = nota-fiscal.cdd-embarq  AND
                                    it-pre-fat.nr-embarque = nota-fiscal.nr-embarque AND
                                    it-pre-fat.nr-resumo   = nota-fiscal.nr-resumo   NO-LOCK:
                
                                    FIND FIRST transporte WHERE
                                        transporte.nome-abrev = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
                                    FIND FIRST int-transporte WHERE
                                        int-transporte.cod-trans = transporte.cod-trans NO-LOCK NO-ERROR.
    
                                    IF AVAIL int-transporte AND int-transporte.separa-uf = YES THEN DO:
                                        
                                        FIND FIRST bfwm-docto WHERE
                                            bfwm-docto.cod-estabel      = h-cod-estabel:BUFFER-VALUE                                AND
                                            bfwm-docto.cod-local        = h-cod-local:BUFFER-VALUE                                  AND
                                            bfwm-docto.num-docto        = STRING(it-pre-fat.cdd-embarq ) + "-" + nota-fiscal.estado AND
                                            bfwm-docto.ind-origem-docto = 5                                                         NO-LOCK NO-ERROR.
                                        
                                        IF AVAIL bfwm-docto AND bfwm-docto.ind-sit = 1 /* AND 
                                            CAN-FIND(FIRST wm-box-movto OF bfwm-docto WHERE
                                                     wm-box-movto.ind-status <> 1 NO-LOCK) */ THEN DO:
                                             RUN piCreateError (INPUT "Documento WMS em processo de Separaá∆o. ê necess†rio concluir a separaá∆o para lanáar a devoluá∆o").
                                             RETURN "NOK":U.
                                        END.
                                    END.
                                    ELSE DO:
                                        FIND FIRST bfwm-docto WHERE
                                            bfwm-docto.cod-estabel      = h-cod-estabel:BUFFER-VALUE     AND
                                            bfwm-docto.cod-local        = h-cod-local:BUFFER-VALUE       AND
                                            bfwm-docto.num-docto        = STRING(it-pre-fat.cdd-embarq ) AND
                                            bfwm-docto.ind-origem-docto = 5                              NO-LOCK NO-ERROR.
                                        IF AVAIL bfwm-docto AND bfwm-docto.ind-sit = 1 /* AND 
                                           CAN-FIND(FIRST wm-box-movto OF bfwm-docto WHERE
                                                    wm-box-movto.ind-status <> 1 NO-LOCK) */ THEN DO:
                                            RUN piCreateError (INPUT "Documento WMS em processo de Separaá∆o. ê necess†rio concluir a separaá∆o para lanáar a devoluá∆o").
                                            RETURN "NOK":U.
                                        END.
                                    END.
    
                                    /* Fracionado */
                                    FIND FIRST bfwm-docto WHERE
                                        bfwm-docto.cod-estabel      = h-cod-estabel:BUFFER-VALUE               AND
                                        bfwm-docto.cod-local        = h-cod-local:BUFFER-VALUE                 AND
                                        bfwm-docto.num-docto        = STRING(it-pre-fat.cdd-embarq ) + "-FRAC" AND
                                        bfwm-docto.ind-origem-docto = 5                                        NO-LOCK NO-ERROR.
                                    IF AVAIL bfwm-docto AND bfwm-docto.ind-sit = 1 /* AND 
                                       CAN-FIND(FIRST wm-box-movto OF bfwm-docto WHERE
                                                wm-box-movto.ind-status <> 1 NO-LOCK) */ THEN DO:
                                        RUN piCreateError (INPUT "Documento WMS em processo de Separaá∆o. ê necess†rio concluir a separaá∆o para lanáar a devoluá∆o").
                                        RETURN "NOK":U.
                                    END.
        
                                END.
                            END.
                            
                        END.
                    END.
                    
                END.
            
                IF h-ind-origem-docto:BUFFER-VALUE = 05 THEN DO: 

                    IF CAN-FIND(FIRST wm-docto WHERE
                                wm-docto.cod-estabel      = h-cod-estabel:BUFFER-VALUE AND 
                                wm-docto.cod-local        = h-cod-local:BUFFER-VALUE   AND  
                                wm-docto.num-docto        = h-num-docto:BUFFER-VALUE   AND 
                                wm-docto.ind-origem-docto = 5                          NO-LOCK) THEN DO:

                    END.

                END.

            END.
        END.
    END.
END.

RETURN "OK":U.

PROCEDURE piCancelamento:

    DEF VAR d-qtd-item-aux      LIKE wm-docto-itens.qtd-item    NO-UNDO.
    DEF BUFFER bfWm-docto       FOR wm-docto.

    FOR EACH integra-mft-wms-notas WHERE
        integra-mft-wms-notas.cod-estabel = devol-cli.cod-estabel AND
        integra-mft-wms-notas.serie       = devol-cli.serie       AND
        integra-mft-wms-notas.nr-nota-fis = devol-cli.nr-nota-fis NO-LOCK:

        ASSIGN d-qtd-item-aux = integra-mft-wms-notas.qtd-integra.

        FOR EACH bfwm-docto USE-INDEX idx-docto5 WHERE
            bfwm-docto.cod-estabel      = integra-mft-wms-notas.cod-estabel AND
            bfwm-docto.num-docto        = integra-mft-wms-notas.cod-integra AND
            bfwm-docto.ind-origem-docto = 5                                 NO-LOCK:

            FOR EACH wm-docto-itens OF bfwm-docto WHERE
                wm-docto-itens.cod-item =  integra-mft-wms-notas.it-codigo EXCLUSIVE-LOCK:

                FOR EACH wm-box-movto OF wm-docto-itens NO-LOCK:
                    RUN wmp/wm9022.p (INPUT  ROWID(wm-box-movto),
                                      OUTPUT TABLE RowErrors).
                END.

                IF wm-docto-itens.qtd-item > d-qtd-item-aux THEN DO:
                    ASSIGN wm-docto-itens.qtd-item = wm-docto-itens.qtd-item - d-qtd-item-aux
                           d-qtd-item-aux          = 0. 

                    RUN wmp/wm9020.p (INPUT wm-docto-itens.qtd-item,
                                      INPUT ROWID(wm-docto-itens),
                                      OUTPUT TABLE RowErrors).

                END.
                ELSE DO:
                    ASSIGN d-qtd-item-aux = d-qtd-item-aux - wm-docto-itens.qtd-item.
                    DELETE wm-docto-itens.
                END.


                IF d-qtd-item-aux <= 0 THEN
                    LEAVE.

            END.
            
        END.

    END.

    FOR EACH wm-docto-itens OF wm-docto EXCLUSIVE-LOCK:
        FOR EACH wm-box-movto OF wm-docto-itens NO-LOCK:
            RUN wmp/wm9032.p (INPUT ROWID(wm-box-movto),
                              OUTPUT TABLE RowErrors).
        END.
        IF NOT CAN-FIND(FIRST wm-box-movto OF wm-docto-itens NO-LOCK) THEN
            DELETE wm-docto-itens.
    END.

    IF NOT CAN-FIND(FIRST wm-docto-itens OF wm-docto NO-LOCK) THEN DO:
        FIND CURRENT wm-docto EXCLUSIVE-LOCK NO-ERROR.
        DELETE wm-docto.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piCreateError:

    DEFINE INPUT PARAM pDescError       AS CHAR FORMAT "X(200)"     NO-UNDO.

    DEFINE VARIABLE h-RowErrors   AS HANDLE NO-UNDO.
    DEFINE VARIABLE hBufferField  AS HANDLE NO-UNDO.
    DEFINE VARIABLE hQueryBuffer  AS HANDLE NO-UNDO.
    DEFINE VARIABLE wgh-query     AS HANDLE NO-UNDO.

    DEFINE VARIABLE h-ErrorSequence    AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-ErrorNumber      AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-ErrorDescription AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-ErrorParameters  AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-ErrorType        AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-ErrorHelp        AS HANDLE NO-UNDO.
    DEFINE VARIABLE h-ErrorSubType     AS HANDLE NO-UNDO.

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event      = "initialize"       AND
              tt-epc.cod-parameter  = "handle-RowErrors" NO-LOCK:
        
        h-RowErrors = WIDGET-HANDLE(tt-epc.val-parameter).
        hQueryBuffer = h-RowErrors:DEFAULT-BUFFER-HANDLE.
    
        hQueryBuffer:BUFFER-CREATE.
        hQueryBuffer::ErrorSequence    = 1.  
        hQueryBuffer::ErrorNumber      = 17006.
        hQueryBuffer::ErrorDescription = pDescError.
        hQueryBuffer::ErrorParameters  = pDescError.
        hQueryBuffer::ErrorType        = "ERROR".
        hQueryBuffer::ErrorHelp        = "".      
        hQueryBuffer::ErrorSubType     = "ERROR".
            
    END.

END PROCEDURE.
