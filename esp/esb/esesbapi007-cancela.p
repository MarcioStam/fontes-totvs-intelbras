/*---------------------------------------------------------------------------------------------------*/
/*  esespapi007-Cancela.p  - Api respons†vel pelo cancelamento de uma solicitaá∆o de Benef°cio       */
/*---------------------------------------------------------------------------------------------------*/

{esp/esb/esesbapi007-solicita.i} /*Funá∆o que retorna o nome do benef°cio */
{esp/esb/in/msg0152.i3} /*tt-erro*/
{method/dbotterr.i}
{utp/ut-glob.i}
{esp/esb/esesbapi004-benef.i} /* Temp-table tt-beneficio */
    
DEF TEMP-TABLE tt-erro-cancela LIKE tt-erro.
DEF TEMP-TABLE tt-erro-apb     LIKE tt-erro.

DEF BUFFER b-solicita-price FOR int-solicitacao.

PROCEDURE pi-cancela:
    /*---------------------------------------------------------------------------------------------------*/
    /*                                     C A N C E L A M E N T O                                       */
    /*---------------------------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-solicitacao      AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-descarta-verba       AS LOG  NO-UNDO.
    DEF INPUT  PARAM p-DescricaoSolicitacao AS CHAR FORMAT "x(100)" NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.
    FIND int-solicitacao NO-LOCK
        WHERE int-solicitacao.CodigoSolicitacaoBeneficio = p-cod-solicitacao NO-ERROR.

    /* Verifica se Ç uma pendente */
    IF  int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003 THEN DO:
        RUN pi-CANCELA-solicitacao-pendente (INPUT  p-cod-solicitacao,
                                             INPUT  p-descarta-verba,
                                             INPUT  p-DescricaoSolicitacao,
                                             OUTPUT TABLE tt-erro,
                                             OUTPUT p-ok).
        IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN
            RETURN "NOK".
    END.
    ELSE DO: /* Cancelar a solicitaá∆o que est† apenas como criada no totvs (empenhada) */
            RUN pi-CANCELA-solicitacao-Empenhada (INPUT  p-cod-solicitacao,
                                                  INPUT  p-descarta-verba,
                                                  INPUT  p-DescricaoSolicitacao,
                                                  OUTPUT TABLE tt-erro,
                                                  OUTPUT p-ok).
            IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN
                RETURN "NOK".
        END.

    ASSIGN p-ok = YES.
    RETURN "OK".

END.

PROCEDURE pi-valida-cancelamento:
    /*---------------------------------------------------------------------------------------------------*/
    /*                                             VALIDAÄÂES                                            */
    /*---------------------------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-solicitacao AS CHAR NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.
    
    EMPTY TEMP-TABLE tt-erro.

    IF  CAN-FIND (FIRST int-solicitacao                                 
                    WHERE int-solicitacao.CodigoSolicitacaoBeneficio    = p-cod-solicitacao
                      AND  (int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 OR /*Paga*/
                            int-solicitacao.SituacaoSolicitacaoBeneficio  = 993520006 /*Cancelada*/)) 
    THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Solicitaá∆o j† est† PAGA ou CANCELADA no EMS." ,
                                            INPUT "N∆o foi poss°vel executar a aá∆o requerida." ).
    
        RETURN "NOK".
    END.

    FIND FIRST int-solicitacao NO-LOCK
        WHERE int-solicitacao.CodigoSolicitacaoBeneficio = p-cod-solicitacao NO-ERROR.

    IF  NOT AVAIL int-solicitacao THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT 'Solicitaá∆o n∆o existe no ERP, n∆o pode ser cancelada'   , 
                                            INPUT "").
        RETURN "NOK".
    END.
    

    /* N«O PERMITIR CANCELAMENTO DE SOLICITAÄÂES VINCULADAS A PEDIDO DE VENDA QUE ESTEJAM ATENDIDO TOTALMENTE*/
    IF  int-solicitacao.desc-forma-pagto = "Produto" THEN DO:
        DEF VAR l-atendido-total AS LOG INIT YES NO-UNDO.
        DEF VAR l-existe AS LOG NO-UNDO.
        FOR EACH int-solicitacao-item NO-LOCK
            WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = p-cod-solicitacao
              AND int-solicitacao-item.nr-pedcli <> ""
             BREAK BY int-solicitacao-item.nome-abrev
                   BY int-solicitacao-item.nr-pedcli:
    
            IF  LAST-OF (int-solicitacao-item.nr-pedcli)  THEN DO:
                IF  NOT CAN-FIND (FIRST ped-venda
                                    WHERE ped-venda.nome-abrev  = int-solicitacao-item.nome-abrev
                                      AND ped-venda.nr-pedcli   = int-solicitacao-item.nr-pedcli
                                      AND ped-venda.cod-sit-ped = 3) THEN DO:
                    ASSIGN l-atendido-total = NO.
                    LEAVE.
                END.
            END.
            l-existe = YES.
        END.
        
        IF  l-atendido-total AND l-existe  THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                         INPUT "Pedidos da Solicitaá∆o j† foram faturados",
                                         INPUT "Todos os pedidos da Solicitaá∆o j† est∆o atendido totalmente." ).
            RETURN "NOK".
        END.
    
    END.

    ASSIGN p-ok = YES.
    RETURN "OK".
END.


PROCEDURE pi-CANCELA-solicitacao-pendente:
    /*-------------------------------------------------------------------------------------------- 
        CANCELAR SOLICITAÄÂES QUE Jµ ESTEJAM PENDENTES PODENDO TER OU N«O PEDIDOS RELACIONADOS 
    ---------------------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-solicitacao      AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-descarta-verba       AS LOG  NO-UNDO.
    DEF INPUT  PARAM p-DescricaoSolicitacao AS CHAR FORMAT "x(100)" NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    DEF VAR c-erro                        AS CHAR FORMAT "X(300)" NO-UNDO.
    DEF VAR de-valor-atendido             AS DEC NO-UNDO.
    DEF VAR de-valor-atendido-trim-ant    AS DEC NO-UNDO.
    DEF VAR de-valor-pedido               AS DEC NO-UNDO.
    DEF VAR c-erro-abatimento             AS CHAR FORMAT "X(1000)" NO-UNDO.
    DEF VAR de-atendido-solicitacao       AS DEC NO-UNDO.
    DEF VAR de-pedido-solicitacao         AS DEC NO-UNDO.
    DEF VAR de-atendido-solicitacao-ant   AS DEC NO-UNDO.
    
    EMPTY TEMP-TABLE tt-erro.

    blk-principal:
    DO TRANSACTION
    ON ERROR UNDO blk-principal,LEAVE blk-principal
    ON STOP  UNDO blk-principal,LEAVE blk-principal:

        /* GRAVAR NO ITEM OS VALORES PAGOS E CANCELADOS */
        FOR EACH int-solicitacao-item EXCLUSIVE-LOCK
            WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = p-cod-solicitacao
            BREAK BY int-solicitacao-item.nome-abrev
                  BY int-solicitacao-item.nr-pedcli:
    
            IF  FIRST-OF(int-solicitacao-item.nr-pedcli) THEN 
                ASSIGN de-valor-pedido            = 0
                       de-valor-atendido          = 0
                       de-valor-atendido-trim-ant = 0.

            FIND FIRST ped-item
                   WHERE ped-item.nome-abrev = int-solicitacao-item.nome-abrev
                     AND ped-item.nr-pedcli  = int-solicitacao-item.nr-pedcli
                     AND ped-item.it-codigo  = int-solicitacao-item.CodigoProduto NO-LOCK NO-ERROR.
    
            IF  AVAIL ped-item THEN DO:
                ASSIGN de-valor-pedido            = de-valor-pedido   + (int-solicitacao-item.ValorUnitarioAprovado * ped-item.qt-pedida)
                       de-valor-atendido          = de-valor-atendido + (int-solicitacao-item.ValorUnitarioAprovado * (ped-item.qt-atendida - int-solicitacao-item.qt-ja-atendida-empenho))
                       de-valor-atendido-trim-ant =  de-valor-atendido-trim-ant + (int-solicitacao-item.ValorUnitarioAprovado * int-solicitacao-item.qt-ja-atendida-empenho).
    
                /* Grava valores */
                ASSIGN int-solicitacao-item.QuantidadeCancelada = ped-item.qt-pedida - ped-item.qt-atendida
                       int-solicitacao-item.ValorPago           = (int-solicitacao-item.ValorUnitarioAprovado * (ped-item.qt-atendida - int-solicitacao-item.qt-ja-atendida-empenho))
                       int-solicitacao-item.ValorCancelado      = (int-solicitacao-item.ValorUnitarioAprovado * ped-item.qt-pedida) - 
                                                                  (int-solicitacao-item.ValorUnitarioAprovado * ped-item.qt-atendida).
            END.

            IF  LAST-OF(int-solicitacao-item.nr-pedcli)  THEN DO:
                
                ASSIGN de-atendido-solicitacao     = de-atendido-solicitacao     + de-valor-atendido
                       de-atendido-solicitacao-ant = de-atendido-solicitacao-ant + de-valor-atendido-trim-ant
                       de-pedido-solicitacao       = de-pedido-solicitacao       + de-valor-pedido.
                       

                FIND FIRST ped-venda NO-LOCK
                       WHERE ped-venda.nome-abrev = int-solicitacao-item.nome-abrev
                         AND ped-venda.nr-pedcli  = int-solicitacao-item.nr-pedcli NO-ERROR.
    
                IF  AVAIL ped-venda THEN DO:
    
                    RUN pi-cancela-pedido (OUTPUT c-erro,
                                           OUTPUT p-ok).
    
                    IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
    
                        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                            INPUT "Cancelamento n∆o pìde ser efetuado. ",
                                                            INPUT c-erro).
                        RETURN "NOK".
                    END.
                END.
            END.
        END.

        /* Caso o pedido tenha sido parcialmente atendido e a aá∆o for cancelamento, passa a solicitacao para paga */
        FIND int-solicitacao NO-LOCK
            WHERE int-solicitacao.CodigoSolicitacaoBeneficio = p-cod-solicitacao NO-ERROR.
    
        IF  NOT AVAIL int-solicitacao THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                         INPUT "Erro ao tentar cancelar a solicitaá∆o",
                                         INPUT "Erro devido a n∆o existància da solicitaá∆o." ).
            UNDO blk-principal, RETURN "NOK".
        END.
    
        /* ABATIMENTO DO SALDO Jµ PAGO DO PEDIDO NO FINANCEIRO */
        IF  (de-atendido-solicitacao + de-atendido-solicitacao-ant ) > 0 THEN DO:
    
             /* Quando for Show Room ou Backup, n∆o deve baixar saldo do APB, n∆o existe conta corrente nem t°tulo relacionado */            
             IF  int-solicitacao.tipo-beneficio  <> 04 /* STOCK BACKUP     */  
             AND int-solicitacao.tipo-beneficio  <> 15 /* SHOW ROOM        */  
             THEN DO:
                 RUN esp/esb/esesbapi009-abater-parcial.p (INPUT p-cod-solicitacao,
                                                           OUTPUT TABLE tt-erro,
                                                           OUTPUT p-ok).
              
                 IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
                     RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,                                            
                                                         INPUT "Erro atualizando abatimento de saldo da conta corrente por pedido de venda parcialmente atendido." ,
                                                         INPUT "").   
                     UNDO blk-principal, RETURN "NOK".                                                                     
                 END.
             END.
        END.


        /* ---------------------------------------*/
        /* ATUALIZAR VALOR ABATIDO DA SOLICITACAO */
        /* ---------------------------------------*/
        FIND int-solicitacao EXCLUSIVE-LOCK
            WHERE int-solicitacao.CodigoSolicitacaoBeneficio = p-cod-solicitacao NO-ERROR.
    
        IF  NOT AVAIL int-solicitacao THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                         INPUT "Erro ao tentar cancelar a solicitaá∆o",
                                         INPUT "Erro devido a n∆o existància da solicitaá∆o ou registro sendo utilizado por outro usu†rio" ).
            UNDO blk-principal, RETURN "NOK".
        END.

        IF  (de-atendido-solicitacao + de-atendido-solicitacao-ant ) > 0 THEN DO:
            /*------------------------------------*/
            /*  ATUALIZA O STATUS DA SOLICITAÄ«O  */
            /*------------------------------------*/
            ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio    = 993520004
                   int-solicitacao.RazaoStatusSolicitacaoBeneficio = 993520004
                   int-solicitacao.StatusPagamento                 = IF  de-pedido-solicitacao = (de-atendido-solicitacao + de-atendido-solicitacao-ant) THEN  
                                                                         993520002 /*TOTAL*/ 
                                                                     ELSE 
                                                                         993520001. /*PARCIAL*/
                   /*int-solicitacao.log-enviada = YES.   nao pode, visto que o esesb0000 deve ainda enviar a msg para o CRM, atualizando as quantidades pagas.*/
        END.
        ELSE
            /* MUDAR A SITUAÄ«O DA SOLICITAÄ«O NO EMS QUANDO N«O FOR CANCELAMENTO */
            ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006.
                   /*int-solicitacao.log-enviada = YES.*/

        FIND int-forma-pagto
            WHERE int-forma-pagto.guid-forma-pagto = int-solicitacao.CodigoFormaPagamento NO-LOCK NO-ERROR.
        IF  NOT AVAIL int-forma-pagto THEN do:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "Forma de Pagamento n∆o cadastrada no EMS." ,
                                                INPUT "." ).
            RETURN "NOK".
        END.

        IF  int-solicitacao.Desc-Forma-Pagto = "Produto" THEN
            ASSIGN int-solicitacao.ValorPago      = de-atendido-solicitacao  /*de-atendido-solicitacao-ant*/
                   int-solicitacao.ValorCancelado = de-pedido-solicitacao - de-atendido-solicitacao - de-atendido-solicitacao-ant.
        ELSE
            ASSIGN int-solicitacao.ValorPago      = 0 
                   int-solicitacao.ValorCancelado = int-solicitacao.ValorSolicitado.

        /*-------------------------------------------------------------------------*/
        /*                             DESCARTE DE VERBA                           */
        /*-------------------------------------------------------------------------*/
         ASSIGN int-solicitacao.DescartarVerba       = p-descarta-verba
                int-solicitacao.DescricaoSolicitacao = p-DescricaoSolicitacao.

        IF  p-descarta-verba THEN DO:

              /* Quando for Show Room ou Backup, n∆o deve baixar saldo do APB, n∆o existe conta corrente nem t°tulo relacionado */            
            IF  int-solicitacao.tipo-beneficio  <> 04 /* STOCK BACKUP     */  
            AND int-solicitacao.tipo-beneficio  <> 15 /* SHOW ROOM        */  
            THEN DO:
                RUN pi-Descarta-Verba (INPUT ROWID(int-solicitacao)              ,
                                       INPUT int-solicitacao.cod-emitente        ,
                                       INPUT int-solicitacao.CodigoUnidadeNegocio,
                                       INPUT int-solicitacao.tipo-beneficio      ,
                                       INPUT int-solicitacao.dt-periodo-ini      ,
                                       INPUT int-solicitacao.dt-periodo-fim      ,
                                       INPUT IF int-solicitacao.Desc-Forma-Pagto = "Produto" THEN int-solicitacao.ValorCancelado ELSE int-solicitacao.ValorAbater ,
                                       INPUT IF int-solicitacao.Desc-Forma-Pagto = "Produto" THEN int-solicitacao.ValorCancelado ELSE int-solicitacao.ValorSolicitado,
                                       INPUT IF int-solicitacao.Desc-Forma-Pagto = "Produto" THEN NO ELSE YES, /*se Ç um desconto em duplicada*/
                                       OUTPUT TABLE tt-erro,
                                       OUTPUT p-ok).
    
                IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
                    UNDO blk-principal, RETURN "NOK".
                END.
            END.

        END.

/*         /* Zera os empenhos transferidos */                                           */
/*         FOR EACH int-solicitacao-item EXCLUSIVE-LOCK                                  */
/*             WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = p-cod-solicitacao */
/*             BREAK BY int-solicitacao-item.nome-abrev                                  */
/*                   BY int-solicitacao-item.nr-pedcli:                                  */
/*             ASSIGN int-solicitacao-item.vl-empenho-pago         = 0                   */
/*                    int-solicitacao-item.qt-ja-atendida-empenho  = 0                   */
/*                    int-solicitacao-item.vl-ja-cancelado-empenho = 0                   */
/*                    int-solicitacao-item.qt-ja-cancelada-empenho = 0.                  */
/*         END.                                                                          */
/*                                                                                       */
    END.
    /*Fim transaá∆o*/

    ASSIGN p-ok = YES.
    RETURN "OK".

END.


PROCEDURE pi-CANCELA-solicitacao-Empenhada : 

    /*-------------------------------------------------------------------------------------------- 
        CANCELAR SOLICITAÄÂES QUE Jµ ESTEJAM PENDENTES PODENDO TER OU N«O PEDIDOS RELACIONADOS 
    ---------------------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-solicitacao      AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-descarta-verba       AS LOG  NO-UNDO.
    DEF INPUT  PARAM p-DescricaoSolicitacao AS CHAR FORMAT "x(100)" NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    DEF VAR c-erro            AS CHAR FORMAT "X(300)" NO-UNDO.
    DEF VAR de-valor-atendido AS DEC NO-UNDO.
    DEF VAR de-valor-pedido   AS DEC NO-UNDO.
    DEF VAR c-erro-abatimento AS CHAR FORMAT "X(1000)" NO-UNDO.
    DEF VAR de-atendido-solicitacao AS DEC NO-UNDO.
    
    EMPTY TEMP-TABLE tt-erro.

    blk-principal:
    DO TRANSACTION
    ON ERROR UNDO blk-principal,LEAVE blk-principal
    ON STOP  UNDO blk-principal,LEAVE blk-principal:

        /* GRAVAR NO ITEM OS VALORES PAGOS E CANCELADOS */
        FOR EACH int-solicitacao-item EXCLUSIVE-LOCK
            WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = p-cod-solicitacao
            BREAK BY int-solicitacao-item.nome-abrev
                  BY int-solicitacao-item.nr-pedcli:
            /* Grava valores */
            ASSIGN int-solicitacao-item.QuantidadeCancelada = int-solicitacao-item.QuantidadeAprovada
                   int-solicitacao-item.ValorCancelado      = int-solicitacao-item.ValorTotalAprovado.
        END.

        /* ---------------------------------------*/
        /* ATUALIZAR VALOR ABATIDO DA SOLICITACAO */
        /* ---------------------------------------*/
        FIND int-solicitacao EXCLUSIVE-LOCK
            WHERE int-solicitacao.CodigoSolicitacaoBeneficio = p-cod-solicitacao NO-ERROR.
    
        IF  NOT AVAIL int-solicitacao THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                         INPUT "Erro ao tentar cancelar a solicitaá∆o",
                                         INPUT "Erro devido a n∆o existància da solicitaá∆o ou registro sendo utilizado por outro usu†rio" ).
            UNDO blk-principal, RETURN "NOK".
        END.

        /*------------------------------------*/
        /*  ATUALIZA O STATUS DA SOLICITAÄ«O  */
        /*------------------------------------*/
        ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006
               int-solicitacao.ValorCancelado               = int-solicitacao.ValorSolicitado
               /*int-solicitacao.log-enviada                  = YES*/
               int-solicitacao.DescartarVerba               = p-descarta-verba
               int-solicitacao.DescricaoSolicitacao         = p-DescricaoSolicitacao.


        /*-------------------------------------------------------------------------*/
        /*                             DESCARTE DE VERBA                           */
        /*-------------------------------------------------------------------------*/
        IF  p-descarta-verba THEN DO:

              /* Quando for Show Room ou Backup, n∆o deve baixar saldo do APB, n∆o existe conta corrente nem t°tulo relacionado */            
            IF  int-solicitacao.tipo-beneficio  <> 04 /* STOCK BACKUP     */  
            AND int-solicitacao.tipo-beneficio  <> 15 /* SHOW ROOM        */  
            THEN DO:
                RUN pi-Descarta-Verba (INPUT ROWID(int-solicitacao)              ,
                                       INPUT int-solicitacao.cod-emitente        ,
                                       INPUT int-solicitacao.CodigoUnidadeNegocio,
                                       INPUT int-solicitacao.tipo-beneficio      ,
                                       INPUT int-solicitacao.dt-periodo-ini      ,
                                       INPUT int-solicitacao.dt-periodo-fim      ,
                                       INPUT IF int-solicitacao.Desc-Forma-Pagto = "Produto" THEN int-solicitacao.ValorCancelado ELSE int-solicitacao.ValorAbater,
                                       INPUT IF int-solicitacao.Desc-Forma-Pagto = "Produto" THEN int-solicitacao.ValorCancelado ELSE int-solicitacao.ValorSolicitado,
                                       INPUT IF int-solicitacao.Desc-Forma-Pagto = "Produto" THEN NO ELSE YES, /*se Ç um desconto em duplicada*/
                                       OUTPUT TABLE tt-erro                      ,
                                       OUTPUT p-ok).
    
                IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
                    UNDO blk-principal, RETURN "NOK".
                END.
            END.

        END.
    END.
    /*Fim transaá∆o*/

    ASSIGN p-ok = YES.
    RETURN "OK".


END.

PROCEDURE pi-Descarta-Verba:
    DEF  INPUT PARAM p-row-solicitacao  AS ROWID       NO-UNDO.
    DEF  INPUT PARAM p-canal            AS INTEGER     NO-UNDO.
    DEF  INPUT PARAM p-unidade          AS CHAR        NO-UNDO.
    DEF  INPUT PARAM p-tipo-beneficio   AS INTEGER     NO-UNDO.
    DEF  INPUT PARAM p-periodo-ini      AS DATE        NO-UNDO.
    DEF  INPUT PARAM p-periodo-fim      AS DATE        NO-UNDO.
    DEF  INPUT PARAM p-valor            AS DEC         NO-UNDO.
    DEF  INPUT PARAM p-valor-verba-canc AS DEC         NO-UNDO.
    DEF  INPUT PARAM p-desconto-duplic  AS LOG         NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.
    DEF OUTPUT PARAM p-ok               AS LOG INIT NO NO-UNDO.

    IF  NOT AVAIL int-solicitacao THEN
        FIND FIRST int-solicitacao NO-LOCK
            WHERE rowid(int-solicitacao) = p-row-solicitacao NO-ERROR.
    
    IF  NOT AVAIL int-solicitacao THEN
        RETURN "NOK".

    blk-novo:
    DO TRANSACTION
    ON ERROR UNDO blk-novo,LEAVE blk-novo
    ON STOP  UNDO blk-novo,LEAVE blk-novo:
        /* Localizar a conta corrente para abater o valor */
        FIND int-cc-benef EXCLUSIVE-LOCK
             WHERE int-cc-benef.canal          = p-canal
               AND int-cc-benef.unid-neg       = p-unidade
               AND int-cc-benef.tipo-beneficio = p-tipo-beneficio
               AND int-cc-benef.dt-periodo-ini = p-periodo-ini
               AND int-cc-benef.dt-periodo-fim = p-periodo-fim
               AND int-cc-benef.tp-movto       = 2 /* DESPESA */
               AND int-cc-benef.id-status      = 1 /* ATIVO   */ NO-ERROR.
        IF  NOT AVAIL int-cc-benef THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                         INPUT "Erro ao tentar descartar empenho de saldo da conta corrente do benef°cio",
                                         INPUT "Erro devido de conta corrente ou o registro est† sendo utilizado por outro usu†rio" ).
            UNDO blk-novo, RETURN "NOK".
        END.
    
        IF  AVAIL int-cc-benef THEN DO:
            ASSIGN int-cc-benef.VerbaCancelada = int-cc-benef.VerbaCancelada + p-valor-verba-canc.
            
            IF  int-cc-benef.tipo-beneficio     <> 22
            AND int-solicitacao.tipo-beneficio  <> 04 
            AND int-solicitacao.tipo-beneficio  <> 15 
            /*AND int-solicitacao.tipo-beneficio  <> 21 /*VMC*/ */ THEN DO:
                RUN pi-atualiza-titulo (INPUT p-valor,
                                        INPUT p-desconto-duplic,
                                        OUTPUT TABLE tt-erro,
                                        OUTPUT p-ok).
    
                IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
                    UNDO blk-novo, RETURN "NOK".
                END.
            END.
        END.
    END.

    ASSIGN p-ok = YES.
    RETURN "OK".
END.

PROCEDURE pi-cancela-pedido:

    DEF OUTPUT PARAM p-erro AS CHAR FORMAT "X(1000)" INIT "" NO-UNDO.
    DEF OUTPUT PARAM p-ok   AS LOG INIT NO NO-UNDO.

    DEF VAR bo-ped-venda-can  AS HANDLE  NO-UNDO.

    IF  ped-venda.cod-sit-ped = 3 /* Total*/ THEN DO:
        ASSIGN p-ok = YES.
        RETURN "OK".
    END.

    IF  ped-venda.cod-sit-ped = 5 /* Suspenso */ THEN DO:
        ASSIGN p-erro = "Pedido est† suspenso. Para cancelar o pedido Ç necess†ria sua reabertura.".
        RETURN "NOK".
    END.


    IF NOT VALID-HANDLE(bo-ped-venda-can) 
    OR bo-ped-venda-can:TYPE <> "PROCEDURE":U 
    OR bo-ped-venda-can:FILE-NAME <> "dibo/bodi159can.p" THEN
        RUN dibo/bodi159can.p PERSISTENT SET bo-ped-venda-can.

    RUN emptyRowErrors  IN bo-ped-venda-can.
    RUN setUserLog IN bo-ped-venda-can (INPUT c-seg-usuario).

    RUN validateCancelation IN bo-ped-venda-can (INPUT  ROWID(ped-venda),
                                                 OUTPUT TABLE Rowerrors).

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH rowErrors
            WHERE RowErrors.ErrorType <> "INTERNAL"
              AND RowErrors.ErrorSubType = "Error":U:
            ASSIGN p-erro = p-erro + string(RowErrors.ErrorNumber) + " - " + RowErrors.errorDescription + ". " + RowErrors.errorHelp +  "; "+ CHR(10).
        END.
        
        IF  VALID-HANDLE (bo-ped-venda-can) THEN DO:
            RUN Destroy IN bo-ped-venda-can.
            ASSIGN bo-ped-venda-can = ?.
        END.
        IF  p-erro <> "" THEN
            RETURN "NOK":U.
    END.
    
    RUN inputReopenQuotation IN bo-ped-venda-can(INPUT NO).
    RUN updateCancelation    IN bo-ped-venda-can(INPUT ROWID(ped-venda),
                                                 INPUT "Cancelamento de pedido atravÇs de Cancelamento da Solicitaá∆o vinculada no CRM",
                                                 INPUT TODAY,
                                                 INPUT 13).

    RUN getRowErrors IN bo-ped-venda-can (OUTPUT TABLE RowErrors). 

    RUN Destroy IN bo-ped-venda-can.
    ASSIGN bo-ped-venda-can = ?.
    
    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH rowErrors
            WHERE RowErrors.ErrorType <> "INTERNAL"
              AND RowErrors.ErrorSubType = "Error":U:

            ASSIGN p-erro = p-erro + string(RowErrors.ErrorNumber) + RowErrors.errorDescription + ". " + RowErrors.errorHelp +  "; "+ CHR(10).
            
        END.
        IF  p-erro <> "" THEN
            RETURN "NOK":U.
    END.

    ASSIGN p-ok = YES.
    RETURN "OK".

END PROCEDURE.

{esp/esb/esesbapi009-abater-parcial.i "int-cc-benef" } /* procedure abater t°tulo */

PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.
