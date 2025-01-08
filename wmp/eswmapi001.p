/********************************************************************************
**  Programa: ESWMAPI001.p                                  
**  Data....: NOVEMBRO/2015
**  Autor...: SCM Concept Consultoria e Desenvolvimento 
**  Objetivo: API de criacao de Documento RETIRADA
********************************************************************************/

/* Include com a Definicao da Temp-Table RowErrors */
{method/dbotterr.i}
{cdp/cdcfgdis.i}
{include/i_dbvers.i}
{cdp/cd0667.i}
{wmp/wm9000.i}
/* Engenharia Separacao MFT x Embarques */
{eqp/eq9999.i}

/* PARAMETROS DO PROGRAMA */
DEF INPUT-OUTPUT PARAM TABLE FOR ttWm-docto.
DEF INPUT-OUTPUT PARAM TABLE FOR ttWm-docto-itens.
DEF OUTPUT PARAM TABLE FOR RowErrors.

/* Variaveis handle */
DEFINE VARIABLE h-bosc047         as handle                    NO-UNDO.

/* Variaveis Like */
DEFINE VARIABLE d-qtd-alocado     LIKE wm-box-movto.qtd-item   NO-UNDO.
DEFINE VARIABLE d-qtd-dev-picking LIKE Wm-docto-itens.qtd-item NO-UNDO.

/* Variaveis Character */
DEFINE VARIABLE c-cod-local  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-sequencia  AS INTEGER     NO-UNDO.

/* Definicao de Temp-table */
DEF TEMP-TABLE ttWm-doctoPicking LIKE ttWm-docto.
DEF TEMP-TABLE ttWm-doctoItensPicking LIKE ttWm-docto-itens.

/* Instancia BO */
RUN scbo/bosc047.p PERSISTENT SET h-bosc047.

/* Verifica se tabela possui registro */
FIND FIRST ttWm-docto NO-LOCK NO-ERROR.
IF NOT AVAIL ttWm-docto THEN DO:
    /*** RUN utp/ut-msgs.p (INPUT "show", INPUT 17006, INPUT "Documento/Embarque n∆o enviado para o WMS"). ***/
    CREATE RowErrors.
    ASSIGN i-sequencia                  = i-sequencia + 1
           RowErrors.errorsequence      = i-sequencia
           RowErrors.errornumber        = 17006
           RowErrors.errordescription   = "Documento/Embarque n∆o enviado para o WMS"
           RowErrors.errortype          = "error"
           RowErrors.ErrorSubType       = "ERROR":U
           RowErrors.errorhelp          = "Documento/Embarque n∆o enviado para o WMS".
    RETURN 'NOK'.
END.

/* Inicio logica do programa */
FOR FIRST ttWm-docto:

    /* Retorna Local do WMS */
    run getLocalDepositoEstab in h-bosc047 (INPUT  ttWm-docto.cod-estab,
                                            INPUT  ttWm-docto.cod-depos,
                                            OUTPUT ttWm-docto.cod-local).
    
    /* Verifica se Ç alteracao */
    FIND FIRST wm-docto NO-LOCK
         WHERE wm-docto.cod-estabel     = ttWm-docto.cod-estabel
           AND wm-docto.cod-local       = ttWm-docto.cod-local
           AND wm-docto.dt-implan-docto = ttWm-docto.dt-implan-docto
           AND wm-docto.num-docto       = ttWm-docto.num-docto       NO-ERROR.
    IF AVAIL wm-docto THEN
        ASSIGN ttWm-docto.alteracao = YES.
    ELSE 
        ASSIGN ttWm-docto.alteracao = NO.

    /* Trata alteracao do documento */
    IF ttWm-docto.alteracao = YES THEN DO:
        /* Carrega ID do documento na temp-table tt-docto*/
        ASSIGN ttwm-docto.id-docto = wm-docto.id-docto.
        /* Carrega ID do documento na temp-table tt-docto-itens*/
        FOR EACH ttWm-docto-itens:
            ASSIGN ttWm-docto-itens.id-docto  = wm-docto.id-docto
                   ttWm-docto-itens.cod-local = Wm-docto.cod-local. 
        END.

        /* Leitura Tabela wm-docto-itens */
        FOR EACH wm-docto-itens EXCLUSIVE-LOCK
           WHERE Wm-docto-itens.cod-estabel  = Wm-docto.cod-estabel
             AND Wm-docto-itens.cod-local    = Wm-docto.cod-local
             AND Wm-docto-itens.id-docto     = Wm-docto.id-docto:

           FIND FIRST ttWm-docto-itens USE-INDEX codigo
                WHERE ttWm-docto-itens.cod-estabel  = Wm-docto-itens.cod-estabel 
                  AND ttWm-docto-itens.cod-local    = Wm-docto-itens.cod-local   
                  AND ttWm-docto-itens.id-docto     = Wm-docto-itens.id-docto    
                  AND ttWm-docto-itens.num-seq-item = Wm-docto-itens.num-seq-item NO-ERROR.
            IF AVAIL ttWm-docto-itens THEN DO:
            
                 ASSIGN ttWm-docto-itens.alteracao      = YES
                        ttWm-docto-itens.dt-atualizacao = TODAY
                        ttWm-docto-itens.gera-sugestao  = YES.

                FOR EACH wm-box-movto
                   WHERE wm-box-movto.cod-estabel      = wm-docto-itens.cod-estabel
                     AND wm-box-movto.cod-local        = wm-docto-itens.cod-local
                     AND wm-box-movto.id-docto         = wm-docto-itens.id-docto
                     AND wm-box-movto.num-seq-item     = wm-docto-itens.num-seq-item
                     AND wm-box-movto.ind-tipo-movto   = 2 /* Saida */ NO-LOCK:

                    /* Se o movimento estiver concluido e a quantidade enviada for menor
                       que a quantidade ja alocada no documento, sera criado um documento de entrada
                       com a quantidade correspondente a diferenca entre as quantidades */
                    IF wm-box-movto.ind-status-movto = 3 THEN DO:
                        IF ttWm-docto-itens.qtd-item < (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem) THEN DO:
                            ASSIGN d-qtd-dev-picking = (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem) - ttWm-docto-itens.qtd-item.

                            RUN pi-cria-dev-picking.
                            
                        END.
                    END.
                    ELSE DO:
                        /*Desfaz a Sugestao de Retirada*/
                        EMPTY TEMP-TABLE RowErrors.
                        RUN wmp/wm9022.p (INPUT ROWID(wm-box-movto),
                                          OUTPUT TABLE RowErrors).
                        IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
                            /* Altera quantidade do item no documento */
                            ASSIGN Wm-docto-itens.qtd-item = ttWm-docto-itens.qtd-item.
                        END.
                        ELSE DO:
                            /* Destroy handle */
                            IF VALID-HANDLE(h-bosc047) THEN
                                RUN destroy IN h-bosc047.
                            RETURN 'NOK'.
                        END.
                    END.
                END.
                /* Verifica Quantidade Alocada no Documento */
                ASSIGN d-qtd-alocado = 0.
                FOR EACH wm-box-movto
                   WHERE wm-box-movto.cod-estabel      = wm-docto-itens.cod-estabel  
                     AND wm-box-movto.cod-local        = wm-docto-itens.cod-local    
                     AND wm-box-movto.id-docto         = wm-docto-itens.id-docto     
                     AND wm-box-movto.num-seq-item     = wm-docto-itens.num-seq-item 
                     AND wm-box-movto.ind-tipo-movto   = 2 /* Sa≠da */ NO-LOCK:
                    ASSIGN d-qtd-alocado = d-qtd-alocado + wm-box-movto.qtd-item * wm-box-movto.qti-embalagem.
                END.
                
                /* Refaz a sugestao de Retirada se a quantidade for maior que a quantidade enviada ao WMS pelo Fat. */
                IF d-qtd-alocado < ttWm-docto-itens.qtd-item THEN DO:
                    EMPTY TEMP-TABLE RowErrors.
                    RUN wmp/wm9020.p (INPUT  Wm-docto-itens.qtd-item - d-qtd-alocado,
                                      INPUT  ROWID(Wm-docto-itens),
                                      OUTPUT TABLE RowErrors).
                END.
                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    /* Destroy handle */
                    IF VALID-HANDLE(h-bosc047) THEN
                        RUN destroy IN h-bosc047.
                    RETURN 'NOK'.
                END.

            END.
        END.
    END.
    /* Criacao de documento */
    ELSE DO:
        /* Grava Local na tabela de itens */
        FOR EACH ttwm-docto-itens NO-LOCK:
            ASSIGN ttWm-docto-itens.cod-local = ttWm-docto.cod-local.
        END.
    END.
END.

PROCEDURE pi-cria-dev-picking.
    /* Se a situacao do movimento estiver concluida, 
       cria documento (Entrada ) de dev de Picking */

    CREATE ttWm-doctoPicking.
    ASSIGN ttWm-doctoPicking.cod-estabel         = ttWm-docto.cod-estabel
           ttWm-doctoPicking.cod-local           = ttWm-docto.cod-local
           ttWm-doctoPicking.dt-implan-docto     = today
           ttWm-doctoPicking.id-docto            = 0
           ttWm-doctoPicking.ind-origem-docto    = 9 /* Devolucao de Picking */
           ttWm-doctoPicking.ind-sit-docto       = 1
           ttWm-doctoPicking.ind-tipo-trans      = 1
           ttWm-doctoPicking.num-docto           = string("Dev.Picking-") + STRING(ttWm-docto.num-docto)
           ttWm-doctoPicking.alteracao           = NO
           ttWm-doctoPicking.cdd-embarq          = ttWm-docto.cdd-embarq
           ttWm-doctoPicking.nr-resumo           = ttWm-docto.nr-resumo.

    CREATE ttWm-doctoItensPicking.               
    ASSIGN ttWm-doctoItensPicking.cod-estabel    = wm-box-movto.cod-estabel
           ttWm-doctoItensPicking.cod-item       = wm-box-movto.cod-item
           ttWm-doctoItensPicking.cod-local      = wm-box-movto.cod-local
           ttWm-doctoItensPicking.cod-refer      = wm-box-movto.cod-refer
           ttWm-doctoItensPicking.dt-atualizacao = TODAY
           ttWm-doctoItensPicking.cod-doca       = 0
           ttWm-doctoItensPicking.id-docto       = 0
           ttWm-doctoItensPicking.ind-sit-movto  = 1
           ttWm-doctoItensPicking.num-seq-item   = wm-box-movto.num-seq-item
           ttWm-doctoItensPicking.qtd-item       = d-qtd-dev-picking
           ttWm-doctoItensPicking.qtd-peso       = 0
           ttWm-doctoItensPicking.alteracao      = NO
           ttWm-doctoItensPicking.gera-sugestao  = YES
           ttWm-doctoItensPicking.num-docto      = string("Dev.Picking-") + STRING(ttWm-docto.num-docto).

    /* Criacao do documento de entrada com Origem do Documento 9 - Dev Picking */
    EMPTY TEMP-TABLE RowErrors.
    RUN wmp/wm9000.p (INPUT-OUTPUT TABLE ttWm-doctoPicking,
                      INPUT-OUTPUT TABLE ttWm-doctoItensPicking,
                      INPUT-OUTPUT TABLE ttWm-etiqueta,
                      OUTPUT       TABLE RowErrors).
    IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
        /* Destroy handle */
        IF VALID-HANDLE(h-bosc047) THEN
            RUN destroy IN h-bosc047.
        RETURN "NOK":U.
    END.

    RETURN "OK".

END PROCEDURE.

/* Somente Chama a API caso o docto nao exista ainda, alteracoes nao serao feitas via API*/
FIND FIRST ttWm-docto NO-ERROR.
IF ttWm-docto.alteracao = NO THEN DO:
    IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
        EMPTY TEMP-TABLE RowErrors.
        RUN wmp/wm9000.p (INPUT-OUTPUT TABLE ttWm-docto,
                          INPUT-OUTPUT TABLE ttWm-docto-itens,
                          INPUT-OUTPUT TABLE ttWm-etiqueta,
                          OUTPUT       TABLE RowErrors).
        IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
            /* Destroy handle */
            IF VALID-HANDLE(h-bosc047) THEN
                RUN destroy IN h-bosc047.
            RETURN "NOK":U.
        END.
    END.
END.

/* Destroy handle */
IF VALID-HANDLE(h-bosc047) THEN
    RUN destroy IN h-bosc047.
